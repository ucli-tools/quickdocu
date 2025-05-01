#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_NAME=$(basename "$SCRIPT_PATH")

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Help function
help() {
    clear
    echo -e "${BOLD}${BLUE}=========================================${NC}"
    echo -e "${BOLD}${BLUE}       QuickDocu: Docusaurus Config Splitter     ${NC}"
    echo -e "${BOLD}${BLUE}=========================================${NC}"
    echo
    echo -e "${CYAN}A tool for splitting Docusaurus configuration into modular components${NC}"
    echo -e "${CYAN}and managing configuration files more effectively.${NC}"
    echo
    echo -e "${YELLOW}Usage:${NC} ${BOLD}quickdocu [COMMAND]${NC}"
    echo
    echo -e "${GREEN}Commands:${NC}"
    echo -e "  ${BOLD}split${NC}      Split docusaurus.config.ts into modular components"
    echo -e "  ${BOLD}install${NC}    Install QuickDocu (requires sudo)"
    echo -e "  ${BOLD}uninstall${NC}  Uninstall QuickDocu (requires sudo)"
    echo -e "  ${BOLD}help${NC}       Display this help message"
    echo
    echo -e "${YELLOW}Examples:${NC}"
    echo -e "  ${BOLD}quickdocu split${NC}"
    echo -e "  ${BOLD}sudo quickdocu install${NC}"
    echo -e "  ${BOLD}sudo quickdocu uninstall${NC}"
    echo
}

# Function to split configuration
split_config() {
    if [ ! -f "docusaurus.config.ts" ]; then
        echo -e "${RED}Error: docusaurus.config.ts not found in current directory${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Starting configuration split...${NC}"

    # Create cfg directory if it doesn't exist
    mkdir -p cfg

    # Extract configurations using Node.js
    node -e "
    try {
        const fs = require('fs');
        const content = fs.readFileSync('docusaurus.config.ts', 'utf8');

        // Function to safely extract content between braces
        function extractBracesContent(str, startIndex) {
            let count = 1;
            let i = startIndex;
            while (count > 0 && i < str.length) {
                i++;
                if (str[i] === '{') count++;
                if (str[i] === '}') count--;
            }
            return str.substring(startIndex, i + 1);
        }

        // Extract navbar
        const navbarStart = content.indexOf('navbar:');
        if (navbarStart !== -1) {
            const navbarContentStart = content.indexOf('{', navbarStart);
            const navbarContent = extractBracesContent(content, navbarContentStart);
            const navbarMatch = content.match(/navbar:[\\s]*{[\\s]*title:[\\s]*['\"]([^'\"]+)['\"]/) || ['', ''];
            const navbar = {
                title: navbarMatch[1],
                items: eval('(' + navbarContent + ')').items
            };
            fs.writeFileSync('cfg/navbar.json', JSON.stringify(navbar, null, 2));
            console.log('Created: cfg/navbar.json');
        }

        // Extract footer
        const footerStart = content.indexOf('footer:');
        if (footerStart !== -1) {
            const footerContentStart = content.indexOf('{', footerStart);
            const footerContent = extractBracesContent(content, footerContentStart);
            const footer = eval('(' + footerContent + ')');
            fs.writeFileSync('cfg/footer.json', JSON.stringify(footer, null, 2));
            console.log('Created: cfg/footer.json');
        }

        // Extract main configuration
        const titleMatch = content.match(/title:[\\s]*['\"]([^'\"]+)['\"]/) || ['', ''];
        const taglineMatch = content.match(/tagline:[\\s]*['\"]([^'\"]+)['\"]/) || ['', ''];
        const faviconMatch = content.match(/favicon:[\\s]*['\"]([^'\"]+)['\"]/) || ['', ''];
        const urlMatch = content.match(/url:[\\s]*['\"]([^'\"]+)['\"]/) || ['', ''];
        const baseUrlMatch = content.match(/baseUrl:[\\s]*['\"]([^'\"]+)['\"]/) || ['', ''];
        const imageMatch = content.match(/image:[\\s]*['\"]([^'\"]+)['\"]/) || ['', ''];

        const main = {
            title: titleMatch[1],
            tagline: taglineMatch[1],
            favicon: faviconMatch[1],
            url: urlMatch[1],
            baseUrl: baseUrlMatch[1],
            image: imageMatch[1],
            metadata: {
                description: taglineMatch[1],  // Use tagline as description
                image: 'https://info.ourworld.tf/img/' + imageMatch[1].replace('img/', ''),  // Format image URL
                title: titleMatch[1]  // Use title as metadata title
            },
            buildDest: 'root@info.ourworld.tf:/root/hero/www/info',  // Static value
            buildDestDev: 'root@info.ourworld.tf:/root/hero/www/infodev'  // Static value
        };

        fs.writeFileSync('cfg/main.json', JSON.stringify(main, null, 2));
        console.log('Created: cfg/main.json');
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
    "

    # Create docusaurus1.config.ts
    echo -e "${CYAN}Creating:${NC} docusaurus1.config.ts"
    cat > docusaurus1.config.ts << 'EOL'
import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import navbar from './cfg/navbar.json';
import footer from './cfg/footer.json';
import main from './cfg/main.json';

const config: Config = {
  title: main.title,
  tagline: main.tagline,
  favicon: main.favicon,

  url: main.url,
  baseUrl: main.baseUrl,

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid'],

  scripts: [
    {
      src: '/js/crisp.js',
      async: false,
    },
  ],

  themeConfig: {
    colorMode: {
      defaultMode: "dark",
      disableSwitch: true,
      respectPrefersColorScheme: false
    },
    image: main.image,
    metadata: [
      { name: 'description', content: main.metadata.description },
      { property: 'og:image', content: main.metadata.image },
      { property: 'og:description', content: main.metadata.description },
      { property: 'og:title', content: main.metadata.title },
    ],
    navbar: navbar,
    footer: footer,
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  },
};

export default config;
EOL

    # Rename docusaurus.config.ts to docusaurus.config.ts.archive
    if [ -f "docusaurus.config.ts" ]; then
        mv docusaurus.config.ts docusaurus.config.ts.archive
        echo -e "${CYAN}Renamed:${NC} docusaurus.config.ts -> docusaurus.config.ts.archive"
    fi

    # Rename docusaurus1.config.ts to docusaurus.config.ts
    if [ -f "docusaurus1.config.ts" ]; then
        mv docusaurus1.config.ts docusaurus.config.ts
        echo -e "${CYAN}Renamed:${NC} docusaurus1.config.ts -> docusaurus.config.ts"
    fi

    echo -e "${GREEN}Configuration split completed successfully!${NC}"
}

# Function to install the script
install() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run the install function with sudo.${NC}"
        exit 1
    fi
    
    cp "$SCRIPT_PATH" /usr/local/bin/quickdocu
    chmod +x /usr/local/bin/quickdocu
    
    echo -e "${GREEN}Installation successful. You can now use 'quickdocu' from any directory.${NC}"
}

# Function to uninstall the script
uninstall() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run the uninstall function with sudo.${NC}"
        exit 1
    fi
    
    if [ -f /usr/local/bin/quickdocu ]; then
        rm /usr/local/bin/quickdocu
        echo -e "${GREEN}QuickDocu has been uninstalled successfully.${NC}"
    else
        echo -e "${YELLOW}QuickDocu is not installed in /usr/local/bin.${NC}"
    fi
}

# Main script logic
if [[ $# -eq 0 ]]; then
    split_config
    exit 0
fi

case "$1" in
    "split")
        split_config
        ;;
    "install")
        install
        ;;
    "uninstall")
        uninstall
        ;;
    "help")
        help
        ;;
    *)
        echo -e "${RED}Invalid option. Use 'quickdocu help' for usage information.${NC}"
        exit 1
        ;;
esac