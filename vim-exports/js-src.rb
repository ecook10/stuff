require 'pathname'

def get_export_names(export_line, export_file_path)
    module_name = File.basename(export_file_path).split('.')[0]

    if /^exports?[ \.\[]\'?default/ =~ export_line or /^module\.exports =/ =~ export_line
        [module_name]

    elsif /^export {(.*)}/ =~ export_line
        $~[1].split(',').map do |export|
            if /\w* as (\w*)/ =~ export
                "#{module_name}.#{$~[1]}"
            else
                "#{module_name}.#{export.strip}"
            end
        end

    elsif /^export \w* (\w*)/ =~ export_line || /^exports[\.\[]\'?(\w*)/ =~ export_line
        ["#{module_name}.#{$~[1]}"]

    else
        ["#{module_name}.???"]
    end
end

def find_file_exports(file_path)
    begin
        export_path = File.dirname(file_path).sub(Dir.pwd + '/', '')
        export_file = File.open(file_path, "r")
        export_lines = export_file.select do |line|
            /^export/ =~ line || /^module\.exports =/ =~ line
        end.map do |export_line|
            get_export_names(export_line, file_path).map do |export_name|
                File.join(export_path, export_name)
            end
        end.flatten
    rescue StandardError => e
        puts "Error reading file #{file_path}: #{e.message}"
    end

    export_lines
end

def merge_export_lists(existing, new)
    existing.each do |key, existing_exports|
        existing[key] += new[key] || []
    end
    new.each do |key, new_exports|
        existing[key] ||= exports
    end
end

def find_dir_exports(dir_path, exports = Array.new)
    puts "Reading Directory #{dir_path}"
    begin
        Dir.open(dir_path) do |dir|
            dir.each do |child_name|
                child_path = File.join(dir_path, child_name)
                if File.directory?(child_path) and !['..', '.', 'node_modules'].include?(child_name)
                    exports += find_dir_exports(child_path)
                elsif /\.jsx?$/ =~ child_name
                    exports += find_file_exports(child_path)
                end
            end
        end
    rescue StandardError => e
        puts "Error reading directory #{dir_path}: #{e.message}"
    end
    exports
end

exports = find_dir_exports(File.join(Dir.pwd, ARGV[0] || ""))
file_name = ".scr_exports"
puts "\n\nSuccessfully collected #{exports.length} exports! Writing to file #{file_name}"
File.open(file_name, "w") do |f|
    f.puts(exports)
end
