#!/usr/bin/env bash
PROGRAM_NAME=$(basename "$0")

FILEPATH_1=$1
LAYER_1=$2
FILEPATH_2=$3
LAYER_2=$4
COMPLETE=${5:-true}

function usage {
    echo "Diff schema of 2 feature data layers (readable by ogr2ogr)"
    echo ""
    echo "usage: $PROGRAM_NAME <filepath-1> <layer-1> <filepath-2> <layer-2> [complete]"
    echo "  arguments:"
    echo "  - <filepath-1>: filepath of feature dataset 1"
    echo "  - <layer-1>: layername of layer 1 to compare"
    echo "  - <filepath-2>: filepath of feature dataset 2"
    echo "  - <layer-2>: layername of layer 2 to compare"
    echo "  - [complete]: optional, to consider also length of string/text types, (true|false) default: true"

    exit 1
}
if test "$#" -lt 4; then
    usage
fi
if ! grep -E  -q "^(false|true)$" <<< $COMPLETE;then
    usage
fi

set -euo pipefail

function get-ogr-geom-att(){
    filepath=$1
    layer=$2
    geom_att_name=$(ogrinfo "$filepath" "$layer" -so | grep "Geometry Column" | cut -d= -f2 | xargs)
    geom_att_type=$(ogrinfo "$filepath" "$layer" -so | grep "Geometry:" | cut -d" " -f2)
    echo "${geom_att_name}: ${geom_att_type}"
}

function get-ogr-attributes(){
    filepath=$1
    layer=$2
    complete=${3:-true}
    match=1
    geom_att=$(get-ogr-geom-att "$filepath" "$layer" )
    while read -r line; do
        if $(grep -q "Geometry Column" <<< "$line");then
            match=0
            continue
        fi
        if [[ $match -eq 0 ]];then
            echo $line
        fi
    done<<<$(ogrinfo -so "$filepath" "$layer" ) | sort | 
        (
            [ $complete == 'false' ] && xargs -i echo '{}' | cut -d" " -f1,2 - || xargs -i echo '{}'
        )
    echo "${geom_att}"
}

function compare-attributes-layers(){
    filepath_1=$1
    layer_1=$2
    filepath_2=$3
    layer_2=$4
    complete=${5:-true}
    layer1_attributes=$(get-ogr-attributes "$filepath_1" "$layer_1" "$complete")
    layer2_attributes=$(get-ogr-attributes "$filepath_2" "$layer_2" "$complete")    
    echo "diff ${filepath_1}:${layer_1} - ${filepath_2}:${layer_2}"
    diff <(echo "$layer1_attributes") <(echo "$layer2_attributes")
}

compare-attributes-layers "$FILEPATH_1" "$LAYER_1" "$FILEPATH_2" "$LAYER_2" "$COMPLETE"
