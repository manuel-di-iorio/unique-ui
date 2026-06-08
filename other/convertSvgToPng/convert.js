const sharp = require('sharp');
const path = require('path');
const fs = require('fs');
const files = [
  {
    input: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconClose/eb9cb3c2-a43c-42c5-9f7e-d0b18411629f.svg',
    output: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconClose/eb9cb3c2-a43c-42c5-9f7e-d0b18411629f.png'
  },
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
