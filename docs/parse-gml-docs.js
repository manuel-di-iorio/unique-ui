const fs = require('fs');
const path = require('path');

const SCRIPTS_DIR = path.join(__dirname, '../scripts');
const DOCS_DIR = path.join(__dirname, 'docs/UI Components');

/**
 * Parses JSDoc-style comments in a GML file
 */
function parseGmlFile(filePath) {
    const content = fs.readFileSync(filePath, 'utf8');
    const methods = [];
    
    // Regex to match block comments and their following declarations
    const blockCommentRegex = /\/\*\*([\s\S]*?)\*\/[\s\S]*?(function\s+(\w+)|self\.(\w+)\s*=)/g;
    let match;

    while ((match = blockCommentRegex.exec(content)) !== null) {
        const commentBody = match[1];
        const name = match[3] || match[4];
        
        const doc = {
            name: name,
            desc: '',
            params: [],
            returns: ''
        };

        const lines = commentBody.split('\n');
        lines.forEach(line => {
            const cleanLine = line.replace(/^\s*\*\s*/, '').trim();
            if (!cleanLine) return;

            if (cleanLine.startsWith('@param')) {
                const paramMatch = cleanLine.match(/@param\s+\{(\w+)\}\s+(\w+)\s+(.*)/);
                if (paramMatch) {
                    doc.params.push({
                        type: paramMatch[1],
                        name: paramMatch[2],
                        desc: paramMatch[3]
                    });
                }
            } else if (cleanLine.startsWith('@return')) {
                doc.returns = cleanLine.replace(/@return(s)?/, '').trim();
            } else if (cleanLine.startsWith('@desc') || cleanLine.startsWith('@description')) {
                doc.desc += (doc.desc ? ' ' : '') + cleanLine.replace(/@desc(ription)?/, '').trim();
            } else {
                if (!cleanLine.startsWith('@')) {
                    doc.desc += (doc.desc ? ' ' : '') + cleanLine;
                }
            }
        });

        methods.push(doc);
    }

    return methods;
}

console.log('Scanning GML Scripts for JSDoc documentation...');
if (!fs.existsSync(SCRIPTS_DIR)) {
    console.error('Scripts directory not found at:', SCRIPTS_DIR);
    process.exit(1);
}

const folders = fs.readdirSync(SCRIPTS_DIR);
let totalDocumented = 0;

folders.forEach(folder => {
    const folderPath = path.join(SCRIPTS_DIR, folder);
    if (!fs.statSync(folderPath).isDirectory()) return;

    const gmlFile = path.join(folderPath, `${folder}.gml`);
    if (fs.existsSync(gmlFile)) {
        const parsed = parseGmlFile(gmlFile);
        if (parsed.length > 0) {
            console.log(`\n📄 [${folder}.gml]`);
            parsed.forEach(m => {
                console.log(`  • method: ${m.name}()`);
                if (m.desc) console.log(`    desc:   ${m.desc}`);
                if (m.params.length > 0) {
                    m.params.forEach(p => {
                        console.log(`    param:  {${p.type}} ${p.name} - ${p.desc}`);
                    });
                }
                if (m.returns) console.log(`    return: ${m.returns}`);
            });
            totalDocumented += parsed.length;
        }
    }
});

console.log(`\n✨ GML Documentation Parsing Complete! Found ${totalDocumented} documented methods/functions.`);
