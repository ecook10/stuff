const fs = require('fs');
const lodash = require('lodash');
const pwd = process.cwd();
console.log(pwd);

const parse_package_exports = (err, data) => {
    if (err) throw err;

    const module_exports = lodash.flatMap(Object.keys(JSON.parse(data).dependencies), dep_name => {
        console.log(`\n\nChecking module ${dep_name}`)
        try {
            const exports = lodash.map(Object.keys(require(`${pwd}/node_modules/${dep_name}`)), export_name => (
                export_name == 'default' ? dep_name : `${dep_name}.${export_name}`
            ))
            console.log(`Found ${exports.length} exports`)
            return exports
        } catch(error) {
            console.error(error);
            return [];
        }
    });

    write_package_exports(module_exports);
}

const write_package_exports = exports_list => {
    const file_string = lodash.reduce(exports_list, (curr_file, export_string) => curr_file + export_string + '\n', '');
    console.log(`\n\n\Writing ${exports_list.length} exports to file\n\n${file_string}`)
    fs.writeFileSync(pwd + '/.module_exports', file_string)
}

fs.readFile('./package.json', 'utf8', parse_package_exports);
