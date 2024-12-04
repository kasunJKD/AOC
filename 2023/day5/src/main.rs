use std::fs::File;
use std::io::{self};
use std::io::BufRead;
use regex::Regex;

//seed to soil
//source destination len
//  64 seed    14 soil        2
//  33 seed    15 soil    

#[derive(Debug, PartialEq)]
pub struct ConversionChart {
    pub name: String,
    pub conversions: Vec<Conversion>,
}

#[derive(Debug, PartialEq)]
pub struct Conversion {
    pub source: u64,
    pub destination: u64,
    pub range_len: u64,
}

fn main() ->io::Result<()> {
    let path = "input.txt";
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);

    let mut seeds: Vec<u64> = Vec::new();
    let mut charts: Vec<ConversionChart> = Vec::new();

    let re = Regex::new(r"(\d+) (\d+) (\d+)").unwrap();
    // a regex to match blank lines with optional newline characters
    let blank_re = Regex::new(r"^\s*\n?$").unwrap();

    for line in reader.lines() {
        let line = line?;
        if line.contains("seeds"){
            line.split(":").nth(1).unwrap()
            .split(" ").filter(|s| !s.is_empty())
            .for_each(|s| seeds.push(s.parse::<u64>().unwrap()));
        } else if line.contains("map") {
            let stripped = line.trim().split(" ").nth(0).unwrap();
            charts.push(ConversionChart {
                name: stripped.to_string(),
                conversions: Vec::new(),
            });
        }else if re.is_match(line.as_str()) {
            // conversion line contains numbers
            let caps = re.captures(line.as_str()).unwrap();
            let source = caps.get(2).unwrap().as_str().parse::<u64>().unwrap();
            let destination = caps.get(1).unwrap().as_str().parse::<u64>().unwrap();
            let range_len = caps.get(3).unwrap().as_str().parse::<u64>().unwrap();
            let chart = charts.last_mut().unwrap();
            chart.conversions.push(Conversion {
                source,
                destination,
                range_len,
            });
        } else if blank_re.is_match(line.as_str()) {
            // blank line, do nothing
        } else {
            panic!("Unrecognized line: {}", line);
        }
    }

    println!("seeds{:?}", seeds);
    println!("seeds{:?}", charts);

    let answer = seeds
        .iter()
        .map(|seed| map_seed_to_location(seed, &charts))
        .min()
        .unwrap();

    println!("Lowest location is: {}", answer);


    Ok(())
}

impl ConversionChart {
    pub fn map_number_to_number(&self, source: &u64) -> u64 {
        let destination: u64 = *source;
        for conversion in &self.conversions {
            let possible = conversion.map_number_to_number(destination);
            // if there is a possible conversion, use it if lower than the current destination
            // TODO can there be multiple mappings for a single seed?
            if let Some(new_destination) = possible {
                return new_destination;
            }
        }
        destination
    }
    
}

impl Conversion {
    pub fn map_number_to_number(&self, source: u64) -> Option<u64> {
        if source >= self.source && source < self.source + self.range_len {
            Some(source - self.source + self.destination)
        } else {
            None
        }
    }
}

pub fn map_seed_to_location(seed: &u64, charts: &Vec<ConversionChart>) -> u64 {
    let mut location = *seed;
    for chart in charts {
        location = chart.map_number_to_number(&location);
    }
    location
}