import fs from 'fs'

const worlds = ['Lost Mangroves', 'Autumn Heights', 'Bright Savannah', 'Sea Breeze Cove', 'Juicy Jungle', 'Donkey Kong Island', 'Secret Seclusion']

function importFile(from) {
    const infile = fs.readFileSync(from, 'utf8')
    const data = JSON.parse(infile)
    return data
}

function getCheckInfoFromLocation(location) {
    let checkName = location.name.charAt(0) === '[' ? location.name.substring(location.name.indexOf(' ') + 1) : location.name
    let imagePath = 'images/locations/puzzlepiece.png'
    if (checkName.indexOf('Letter') >= 0) {
        imagePath = `images/locations/${checkName.substring(checkName.indexOf(' ') + 1)}.png`
        checkName = ''
    } else if (checkName.indexOf('Defeat') >= 0) {
        imagePath = `images/locations/${checkName.substring(checkName.indexOf(' ') + 1, checkName.indexOf(','))}.png`
    }

    // TODO: May need to add 'chest_unopened_img' here; just append something to imagePath
    return { name: checkName, 'chest_opened_img': imagePath, 'chest_unopened_img': `${imagePath.substring(imagePath.indexOf('.png'))}_desat.png` }
}

function generateTrackerLocations(locations) {
    const worldObjects = []
    worlds.forEach((world) => {
        worldObjects.push({
            name: world,
            children: []
        })
    })

    locations.forEach((location) => {
        // Victory location is not necessary for tracker
        if (location.name === 'Victory') {
            return
        }

        const worldId = location.region.charAt(1) - 1
        const levels = worldObjects[worldId].children

        // Check if the level has been added as a region yet
        if (levels.filter((level) => level.name === location.region).length <= 0) {
            levels.push({
                name: location.region,
                sections: [],
                'map_locations': [{
                    map: worlds[worldId].replace(/ /g, '').toLowerCase(),
                    // These numbers have to be hardcoded after conversion, so this is just to separate them visually
                    x: 50 * levels.length,
                    y: 355
                }]
            })
        }

        // Add the check as a section
        const level = levels.filter((level) => level.name === location.region)[0]

        // Transform check name and assign check image
        const checkInfo = getCheckInfoFromLocation(location)
        level.sections.push({
            ...checkInfo,
            // Some access rules will still need to be added by hand, but this at least includes all of the level items
            'access_rules': [location.region.substring(1, location.region.indexOf(']')).toLowerCase()],
            // Should be implemented once yaml settings are a thing for manual games
            'visibility_rules': []
        })
    })

    return worldObjects
}

function writeLocations(fileObjects, folder) {
    fileObjects.forEach((value) => {
        const filename = folder + value.name.replace(/ /g, '').toLowerCase() + '.json'
        fs.writeFileSync(filename, JSON.stringify([value]))
    })
}

const locationData = importFile('dkclocs.json')
const fileObjects = generateTrackerLocations(locationData)

try {
    writeLocations(fileObjects, '../locations/')
    console.log('Successfully output all locations')
} catch (e) {
    console.error('Something went wrong', e)
}