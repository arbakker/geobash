# README

Collection of bash scripts to inspect and reproject coordinates, bounding boxes and WKT strings.

Most scripts allow to pass the input geometry (bbox, coordinate or wkt string) to be passed on standard input. When passing geometry on standard input replace the input geometry argument with `-`.

## Requirements

Requires `libproj-dev`, `gdal-bin`  and `perl` to be installed. 

Add directory to PATH (add to `.bashrc` or `.zshrc`):

```
export PATH=${geobash_installation_path}:$PATH
```

## Usage examples

### create GPKG with all tiles of z3 of Dutch tiling scheme (EPSG:28992)

Create GPKG with geometries of all tiles of zoomlevel 3 (nr of tiles per zoomlevel is 2^z and starts at 0) of Dutch tiling scheme (EPSG:28992):

```
zxy2bbox 28992 4/{0..15}/{0..15}  | bbox2wkt | wkt2ogr -  28992 GPKG grid.gpkg grid
```

### show tile boundaries of specific tile of Dutch tiling scheme (EPSG:28992)

```
zxy2bbox 28992 2/2/1  | bboxproj 28992 4326 - | bboxshow
```
