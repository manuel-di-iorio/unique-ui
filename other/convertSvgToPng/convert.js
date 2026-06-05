const sharp = require('sharp');
const path = require('path');
const fs = require('fs');
const files = [
  {
    input: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconCheck/ae378caf-317b-452e-b391-ea1be2aa48ea.svg',
    output: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconCheck/ae378caf-317b-452e-b391-ea1be2aa48ea.png'
  },
  {
    input: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconMenuBar/95f80fd5-f710-4410-8aa0-bcaafc3d089f.svg',
    output: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconMenuBar/95f80fd5-f710-4410-8aa0-bcaafc3d089f.png'
  },
  {
    input: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconState/1089d7a4-e380-45e7-a174-aa1857efe609.svg',
    output: 'c:/Users/Manuel/GameMakerProjects/UniqueUI/sprites/sprUiIconState/1089d7a4-e380-45e7-a174-aa1857efe609.png'
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
