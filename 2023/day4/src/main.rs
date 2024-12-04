use std::fs::File;
use std::io::{self};
use std::io::BufRead;
fn main() ->io::Result<()>{
    let path = "input.txt";
    let file = File::open(path)?;
    let reader = io::BufReader::new(file);

    //read left side make array
    //read right side make array
    //check how many left side exists in right
    // 1 2 4 8 16 32.... 
    // get total

    let mut total = 0;

    for line in reader.lines(){
        let line = line?;
        println!("{:?}", line);

        let (_, value) = line.as_str().trim().split_once(":").unwrap();

        let (left, right) = value.trim().split_once("|").unwrap();
        
        let leftlist = left.trim().split_whitespace().collect::<Vec<&str>>();
        let rightlist = right.trim().split_whitespace().collect::<Vec<&str>>();

        println!("{:?}", leftlist);
        println!("{:?}", rightlist);

        let common_elements: Vec<&str> = leftlist
        .iter()
        .filter(|&&x| rightlist.contains(&x))
        .cloned()
        .collect();

        let count_common_elements = common_elements.len();
        let score = if count_common_elements > 0 {
        2u32.pow(count_common_elements as u32 - 1)
        } else {
            0 // If there are no common elements, set the score to 0
        };

        println!("Score for the line: {}", score);
        total+=score;

        
    }
    
    println!("total: {}", total);
    Ok(())
}
