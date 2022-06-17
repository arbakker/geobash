# README

![Shellcheck](https://github.com/arbakker/geobash/actions/workflows/shellcheck.yml/badge.svg)

Collection of bash scripts to inspect and reproject coordinates, bounding boxes and WKT strings.

Most scripts allow to pass the input geometry (bbox, coordinate or wkt string) to be passed on standard input. When passing geometry on standard input replace the input geometry argument with `-`.

## Requirements

Requires `libproj-dev`, `gdal-bin`  and `perl` to be installed. 

Add directory to PATH (add to `.bashrc` or `.zshrc`):

```sh
export PATH=${geobash_installation_path}:$PATH
```

## Development

Source files are linted with [Shellcheck](https://github.com/koalaman/shellcheck).

## Usage examples

Create GPKG with geometries of all tiles of zoomlevel 3 (nr of tiles per zoomlevel is 2^z, zoomlevel z is zero-based index) of Dutch tiling scheme (EPSG:28992):

```sh
zxy2bbox 28992 4/{0..15}/{0..15}  | bbox2wkt | wkt2ogr -  28992 GPKG grid.gpkg grid
```

----

Show tile boundaries of specific tile (Dutch tiling scheme; EPSG:28992):

```sh
zxy2bbox 28992 2/2/1  | bboxproj 28992 4326 - | bboxshow
```

----

Calculate scale denominator of WMS GetMap request:

```sh
wmsmap2scaledenominator https://service.pdok.nl/hwh/luchtfotorgb/wms/v1_0?SERVICE=WMS&REQUEST=GetMap&VERSION=1.3.0&LAYERS=Actueel_ortho25&BBOX=233328.32,554123.2,233382.08,554176.96&WIDTH=256&HEIGHT=256&CRS=EPSG:28992&FORMAT=image/png
```
