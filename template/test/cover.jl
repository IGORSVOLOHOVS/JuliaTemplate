using Coverage

coverage = process_folder() 
coverage = append!(coverage, process_folder("test"))  
coverage = append!(coverage, process_folder("docs"))  
coverage = append!(coverage, process_folder("build")) 

LCOV.writefile("coverage.info", coverage)
