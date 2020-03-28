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
       "url": "https://intelligide.pkgs.visualstudio.com/0435f2bc-ce0a-4490-ac97-883fb250890d/_packaging/stable/npm/registry/",
       "scopes": [
         "com.arsenstudio.assimp"
       ]
     }
     ...
   ],
   ...
   ```

2. Add the dependency:

   ```json
   "dependencies": {
     ...
     "com.arsenstudio.assimp": "4.1.0"
   }
   ...
   ```

3. Let Unity fetch the package
4. See [Usage](usage.md)
