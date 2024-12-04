use std::fs::File;
use std::io::{self};
use std::io::BufRead;
use std::thread::current;
use regex::Regex;
use std::collections::HashMap;

fn main()->io::Result<()> {
   // 1abc2
//pqr3stu8vwx
//a1b2c3d4e5f
//treb7uchet
    //read line 
    //combine 2 numbers first and last
    //if 1 number exists 
    //same number twice

    let path = "src/input.txt";
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);

    let mut total = 0;
    let re = Regex::new(r"\d").unwrap();
    // for line in reader.lines() {
    //     let line = line?;
    //     let numbers: Vec<i32> = re.find_iter(&line)
    //                                     .filter_map(|m| m.as_str().parse().ok())
    //                                     .collect();

    //     if numbers.len() >= 2 {
    //         let first_number = *numbers.get(0).unwrap_or(&0);
    //         let last_number = *numbers.get(numbers.len() - 1).unwrap_or(&0);

    //         let combined_number = first_number * 10 + last_number;
    //         println!("Combined number: {}", combined_number);
    //         total += combined_number;
    //     } else {
    //         let combined_number = numbers[0] * 10 + numbers[0];
    //         println!("Combined for 1: {}", combined_number);
    //         total += combined_number;
    //     }

    //     println!("Numbers in line: {:?}", numbers);
    // }

    for line in reader.lines() {
        let mut line_val: Vec<String> = Vec::new();
        let line = line?;
        let parts: Vec<String> = split_string(&line);

        for p in parts {
            let val = check_for_word(p.as_str());
            line_val.push(val);
            
        }
        println!("partval: {:?}", line_val);

        let numbers: Vec<i32> = re.find_iter(&line_val.join(""))
                                    .filter_map(|m| m.as_str().parse().ok())
                                    .collect();

        if numbers.len() >= 2 {
            let first_number = *numbers.get(0).unwrap_or(&0);
            let last_number = *numbers.get(numbers.len() - 1).unwrap_or(&0);

            let combined_number = first_number * 10 + last_number;
            println!("Combined number: {}", combined_number);
            total += combined_number;
        } else {
            let combined_number = numbers[0] * 10 + numbers[0];
            println!("Combined for 1: {}", combined_number);
            total += combined_number;
        }

        println!("Numbers in line: {:?}", numbers);

    }

    println!("{:?}", total);

    Ok(())

}

fn check_for_word(input: &str) -> String {
    let words: HashMap<String, &str> = HashMap::from([
        ("one".to_string(), "1"),
        ("two".to_string(), "2"),
        ("three".to_string(), "3"),
        ("four".to_string(), "4"),
        ("five".to_string(), "5"),
        ("six".to_string(), "6"),
        ("seven".to_string(), "7"),
        ("eight".to_string(), "8"),
        ("nine".to_string(), "9"),
    ]);

    let mut replaced = input.to_string();
    for word in words.keys() {
        if input.contains(word) {
            replaced = replaced.replace(word, words.get(word).unwrap());
        }
    }

    replaced
}

fn split_string(s: &str) -> Vec<String> {
    let mut parts = Vec::new();
    let mut current_part = String::new();

    for c in s.chars() {
        if c.is_numeric() {
            if !current_part.is_empty() {
                parts.push(current_part.clone());
                current_part.clear();
            }
            parts.push(c.to_string());
        } else {
            current_part.push(c);
        }
    }

    if !current_part.is_empty() {
        parts.push(current_part);
    }

    parts
}