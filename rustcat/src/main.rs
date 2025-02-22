use clap::Parser;
use std::fs;
use std::io::{stdin, Read, Write};
use regex::Regex;


#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// file in
    #[arg(short, long, default_value = "-")]
    file_in: String,

    /// file out
    #[arg(short = 'o', long, default_value = "-")]
    file_out: String,

    /// regex
    #[arg(short, long, default_value = ".*")]
    regex_str: String
}


fn main() {
    let args = Args::parse();

    // Check input regular expression
    let re_result = Regex::new(&args.regex_str);
    let re = match re_result {
        Ok(r) => r,
        Err(error) => panic!("Bad Regular Expression: {}", error)
    };

    let mut file_buffer = String::new();
    let file: String = {
        if &args.file_in == "-" {
            let file_str_result = stdin().read_to_string(&mut file_buffer);
            match file_str_result {
                Ok(_) => { file_buffer },
                Err(error) => panic!("Error Reading file: {}", error)
            }
        } else {
            let file_str_result = fs::read_to_string(&args.file_in);
            match file_str_result {
                Ok(f) => f,
                Err(error) => panic!("Failed to read file: {}", error)
            }
        }
    };



    let lines = file.split('\n');
    let mut out: Box<dyn Write>  = {

        if &args.file_out == "-" || &args.file_out == "" {
            Box::new(std::io::stdout()) as Box<dyn Write>
        } else {
            match fs::File::create(&args.file_out) {
                Ok(f) => Box::new(f) as Box<dyn Write>,
                Err(error) => panic!("Failed to create file: {}", error)
            }
        }
    };


    for line in lines {
        if re.is_match(line) {
            let mut line_out = String::from(line);
            line_out.push('\n');
            let res = out.write_all(line_out.as_bytes());
            if res.is_err() {
                panic!("Failed to write to file: {}", &args.file_out);
            }
        }
    }

}
