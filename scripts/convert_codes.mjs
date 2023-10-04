import fs from 'fs'

const importFile = (from) => {
    const infile = fs.readFileSync(from, 'utf8')
    const data = JSON.parse(infile)
    return data
}

function writeItems(codes, filename) {
    let output = ''
    Object.keys(codes).forEach((name) => {
        output += `[${codes[name]}] = {"${name.replace(/ /g,"").toLowerCase()}"},\n`
    })
    output = `ITEM_MAPPING = {\n${output.substring(0, output.length - 2)}\n}`
    fs.writeFileSync(filename, output)
}

function writeLocations(codes, locations, filename) {
    const worlds = ['Lost Mangroves', 'Autumn Heights', 'Bright Savannah', 'Sea Breeze Cove', 'Juicy Jungle', 'Donkey Kong Island', 'Secret Seclusion']
    let output = ''
    Object.keys(codes).forEach((name) => {
        // Victory location, not necessary for tracker
        if (name.charAt(0) === '_') {
            return
        }

        const loc = locations.filter((value) => value.name === name)[0]
        const worldId = Number(loc.region.charAt(1)) - 1
        output += `[${codes[name]}] = {"@${worlds[worldId]}/${loc.region}/${name}"},\n`
    })
    output = `LOCATION_MAPPING = {\n${output.substring(0, output.length - 2)}\n}`
    fs.writeFileSync(filename, output)
}


const codeData = importFile('dkccodes.json')["Manual_DonkeyKongCountryTropicalFreeze_JHobz"]
const locationData = importFile('dkclocs.json')

try {
    writeItems(codeData['item_name_to_id'], 'autotracking/item_mapping.lua')
    writeLocations(codeData['location_name_to_id'], locationData, 'autotracking/location_mapping.lua')
    console.log('Successfully output all codes')
} catch (e) {
    console.error('Something went wrong', e)
}