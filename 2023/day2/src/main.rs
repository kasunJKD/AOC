use std::fs::File;
use std::io::{self};
use std::io::BufRead;

fn main()->io::Result<()>  {

    //12R 13G 14B
    //check each set if showed set item val > R or G or B 
    //invalid game
    //calc sum of game ids
    //[game:1,[r,g],[r,g,b]]

    
    let mut total = 0;
    let mut test = 1;
    let mut max_red: Option<i32> = None;
    let mut max_g: Option<i32> = None;
    let mut max_b: Option<i32> = None;

    let path = "input.txt";
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);

    for line in reader.lines() {
        let line = line?;
        let result = parseline(line.as_str());
       

        // let game_number = match result.iter().find(|&x| x[0].0 == "Game") {
        //     Some(game) => game[0].1,
        //     None => 0,
        // };
        let mut found = false;
        let game_value = result.iter()
                         .find(|x| x[0].0 == "Game")
                         .map(|x| x[0].1)
                         .unwrap_or(0);
        test = 1;
        for sub_array in result {
            println!("{:?}", sub_array);
            for (color, count) in sub_array {
                // if color == "red" && count > 12 {
                //     found = true;
                //     break;
                // }
                // else if color == "green" && count > 13 {
                //     found = true;
                //     break;
                // }
                // else if color == "blue" && count > 14 {
                //     found = true;
                //     break;
                // }
                
                if color == "red" {
                match max_red {
                    Some(current_max) => max_red = Some(std::cmp::max(current_max, count)),
                    None => max_red = Some(count),

                }
                }
                if color == "green" {
                match max_red {
                    Some(current_max) => max_g = Some(std::cmp::max(current_max, count)),
                    None => max_g = Some(count),

                }
                }
                if color == "blue" {
                match max_red {
                    Some(current_max) => max_b = Some(std::cmp::max(current_max, count)),
                    None => max_b = Some(count),

                }
                }

                

                
            }

             println!("{:?}", max_red);
              println!("{:?}", max_b);
               println!("{:?}", max_g);

            test = multiply_options(max_red, max_b, max_g, test);
            println!("{:?}", test);

                //let totaltest =
                //let test = count * count 
            
        }

        total+=test;

    }   

    //println!("{:?}", total);
    println!("{:?}", test);
    Ok(())



}

fn parseline(line: &str) -> Vec<Vec<(&str,i32)>> 
{
    let mut result = Vec::new();
    let parts = line.split(':').collect::<Vec<_>>();
    //println!("{:?}", parts);

    for part in parts {
        if part.trim().starts_with("Game") {
            if let Some((_, game_number)) = part.trim().split_once(' ') {                             
                    let val: i32 = game_number.parse().unwrap();
                    result.push(vec![("Game", val)]);               
            }
        } else { 
            let sparts = part.trim().split(';').collect::<Vec<_>>();
            //println!("{:?}", sparts);
            for subpart in sparts{
                let color_counts = subpart.trim().split(',')
                .filter_map(|kv| {
                    let mut iter = kv.trim().split_whitespace();
                    
                    if let (Some(value), Some(key)) = (iter.next(), iter.next()) {
                        //println!("{:?}", key);
                        value.parse::<i32>().ok().map(|v| (key, v))
                    } else {
                        None
                    }
                })
                .collect::<Vec<(&str, i32)>>();
            //println!("{:?}", color_counts);
            if !color_counts.is_empty() {
                result.push(color_counts);
            }
            }       
        }
    }
    result
}

fn multiply_options(a: Option<i32>, b: Option<i32>, c: Option<i32>, integer: i32) -> i32 {
    match (a, b, c) {
        (Some(x), Some(y), Some(z)) => x * y * z * integer,
        _ => 0, // Or any other default value you deem appropriate
    }
}