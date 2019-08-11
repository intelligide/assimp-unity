---
layout: default
title: Accepted File Formats
nav_order: 2
---

# {{ page.title }}
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## With Unity Package Manager

1. Add the scoped repository into the `Packages/manifest.json`

   ```json
   "scopedRegistries": [
     {
       "name": "Assimp",
       "url": "https://pkgs.dev.azure.com/intelligide/Assimp for Unity/_packaging/public/npm/registry/",
       "scopes": [
         "com.arsenstudio.assimp"
       ]
     }
     ...
   ],
   ...
   ```

2. z

   ```json
   "dependencies": {
     ...
     "com.arsenstudio.assimp": "4.1.0"
   }
   ...
   ```

3. Let Unity fetch the package
