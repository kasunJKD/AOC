use std::fs::File;
use std::io::{self};
use std::io::BufRead;

#[derive(Debug, PartialEq)]
pub struct Race {
    pub time: i32,
    pub distance: i32
}
fn main()->io::Result<()>  {

    //(time, distance)
    //(7 9)
    //0 * 7 = 0 (this is the checking distance)
    // 1 * 6 = 6
    // 2 * 5 = 10 etc
    //checkdist > distance
    //each ways to win * each ways to win

    let path = "input.txt";
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);

    let mut races: Vec<Race> = Vec::new();

    for line in reader.lines() {
        let line = line?;

        //println!("{:?}", line);

        if line.contains("Time:") {
            let times: Vec<i32> = line
                .split_whitespace()
                .skip(1)
                .filter_map(|s| s.trim().parse().ok())
                .collect();

            //println!("{:?}", times);
            for &time in &times {
                races.push(Race { time, distance: 0 }); 
            }
        } else if line.contains("Distance") {
            let distances: Vec<i32> = line
                .split_whitespace()
                .skip(1)
                .filter_map(|s| s.trim().parse().ok())
                .collect();

            println!("{:?}", distances);

            for (race, &distance) in races.iter_mut().zip(&distances) {
                race.distance = distance;
            }

            //  let distance_str: String = line
            //     .split_whitespace()
            //     .skip(1)
            //     .collect::<Vec<&str>>()
            //     .join("");

            // let distance: i32 = distance_str.parse().unwrap_or(0);

            // for race in races.iter_mut() {
            //     race.distance = distance;
            // }

        }
    }

    let mut valueMultipleTotal:i32 = 1;

    for race in &races {
        let time = race.time;
        let distance = race.distance;
        let mut counting_time = 0;
        println!("Time: {}, Distance: {}", time, distance);

        for n in 0..time {
            println!("{:?}", n);
            let checkdist = n * (time - n);
            if checkdist > distance {
                counting_time = counting_time + 1;
            }
        }

        valueMultipleTotal = valueMultipleTotal * counting_time;
    }

    println!("{:?}", valueMultipleTotal);

    Ok(())
}
