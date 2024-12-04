use std::fs::File;
use std::io::{self};
use std::io::BufRead;

fn main()->io::Result<()> {
    let path = "input.txt";
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);

    //need to check number end 
    //right left up down
    //if anything other than number or sign
    //add that to total
    //
    //each line [[index,number,row,column]]

    //let mut total = 0;
    
    let mut baseresult: Vec<Vec<(usize, usize, String)>> = Vec::new();
    let mut numberresult: Vec<Vec<(usize, usize, String)>> = Vec::new();

    for (row_number, line) in reader.lines().enumerate() {
         let line = line?;
        let column_number = 0;

        // Separate the trimmed line into an array of characters
        let characters: Vec<String> = line.trim().chars().map(|c| c.to_string()).collect();

        // Create a subarray and push it to the result vector
        let subarray: Vec<(usize, usize, String)> = characters
            .into_iter()
            .enumerate()
            .map(|(col_number, value)| (row_number, col_number + column_number, value))
            .collect();
        
        baseresult.push(subarray);

    }

    let wholegrid: Vec<(usize, usize, String)> = baseresult.into_iter().flat_map(|subarray| subarray).collect();

    let mut filtered_tuples: Vec<(usize, usize, String)> = wholegrid.clone()
        .into_iter()
        .filter(|&(_, _, ref value)| value.chars().all(|c| c.is_digit(10)))
        .collect();

    println!("{:?}", filtered_tuples);

    let positions = [
        (-1, 0),
        (1,0),
        (0,1),
        (0,-1),
        (-1,1),
        (-1,-1),
        (1,-1),
        (1,1)
    ];

    // Create a new list with filtered tuples after removing those near non-number positions
    let new_filtered_tuples: Vec<(usize, usize, String)> = Vec::new();

    for &(row, col, _) in &filtered_tuples {
        for &(dx, dy) in &positions {
            let new_row = (row as isize + dx) as usize;
            let new_col = (col as isize + dy) as usize;

            // Check if the new position is within the bounds of wholegrid
            if wholegrid.iter().any(|&(r, c, _)| r == new_row && c == new_col) {
                let neighbor_value = &wholegrid.iter().find(|&&(r, c, _)| r == new_row && c == new_col).unwrap().2;
                println!("neighbor_value: {:?}", neighbor_value);
                // Check if the neighbor has non-number characters
                if neighbor_value.chars().any(|c| !c.is_digit(10) && c != '.') {
                    println!("Non-number found at position ({}, {}) with value: {}", new_row, new_col, neighbor_value);
                    break;
                }
            }
        }
    }

    println!("New Filtered Tuples: {:?}", new_filtered_tuples);

    Ok(())
}
