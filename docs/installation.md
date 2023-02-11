---
layout: default
title: Installation
nav_order: 2
permalink: /installation/
---

# {{ page.title }}
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## With Unity Package Manager

1. Add a scoped repository into the `Packages/manifest.json`

   ```json
   "scopedRegistries": [
     {
       "name": "Assimp",
       "url": "https://upm.frozenstorminteractive.com/",
       "scopes": [
         "com.frozenstorminteractive"
       ]
     }
     ...
   ],
   ...
   ```

2. Add the dependency:  
(Please check https://upm.frozenstorminteractive.com/ for available versions of assimp.* packages)

   ```json
   "dependencies": {
     ...
     "com.frozenstorminteractive.assimp": "4.1.0-pre.2",
     "com.frozenstorminteractive.assimp.windows": "4.1.0-pre.2",
     "com.frozenstorminteractive.assimp.linux": "4.1.0-pre.2",
   }
   ...
   ```

3. Let Unity fetch the package
4. See [Usage](usage.md)
