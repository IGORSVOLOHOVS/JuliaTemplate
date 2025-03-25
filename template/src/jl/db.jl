using SQLite

if !isdir("build")
    mkdir("build")
end

db = SQLite.DB("build/tmp.db")