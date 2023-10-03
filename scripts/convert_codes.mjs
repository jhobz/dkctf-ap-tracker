import fs from 'fs'

const importFile = (from) => {
    const infile = fs.readFileSync(from, 'utf8')
    const dkcData = JSON.parse(infile)["Manual_DonkeyKongCountryTropicalFreeze_JHobz"]
    return dkcData
}

function writeFile(data, filename) {
    let output = ''
    Object.keys(data).forEach((name) => {
        output += `[${data[name]}] = {"${name.replace(/ /g,"").toLowerCase()}"},\n`
    })
    output = `ITEM_MAPPING = {\n${output.substring(0, output.length - 2)}\n}`
    fs.writeFileSync(filename, output)
}


const dkcData = importFile('dkcdata.json')

try {
    writeFile(dkcData['item_name_to_id'], 'autotracking/item_mapping.lua')
    writeFile(dkcData['location_name_to_id'], 'autotracking/location_mapping.lua')
    console.log('Successfully output all codes')
} catch (e) {
    console.error('Something went wrong', e)
}