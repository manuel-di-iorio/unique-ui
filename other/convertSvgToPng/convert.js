const sharp = require('sharp');
const path = require('path');
const fs = require('fs');
const files = [
  {
    input: 'c:/Users/Manuel/GameMakerProjects/Unique Engine/sprites/sprUiIconTooltip/a2e9eed2-5ee5-4860-9aa8-8bba0707f295.svg',
    output: 'c:/Users/Manuel/GameMakerProjects/Unique Engine/sprites/sprUiIconTooltip/a2e9eed2-5ee5-4860-9aa8-8bba0707f295.png'
  }
];
async function convert() {
  for (const file of files) {
    try {
      console.log(`Converting ${file.input} -> ${file.output}...`);
      if (!fs.existsSync(file.input)) {
        console.error(`Input file not found: ${file.input}`);
        continue;
      }
      await sharp(file.input)
        .resize(64, 64)
        .png()
        .toFile(file.output);
      console.log(`Successfully generated: ${file.output}`);
    } catch (err) {
      console.error(`Error converting ${file.input}:`, err);
    }
  }
}
convert();
