enum SectorMagic : u32 {
    magic                       = 0x00000001,
    unknown                     = 0x00020000,   // something about RAM?
    model_container             = 0x00000002,   // game func: GetModelNum
    mesh_container              = 0x00000004,
    tristrip_container          = 0x00000005,   // GetIndexListAMOModelMesh
    tristrip_03_data            = 0x00030000,
    tristrip_04_data            = 0x00040000,   // triangles with multiple bone deformations
    mesh_material_list          = 0x00050000,   // per mesh material
    mesh_material_per_strip     = 0x00060000,
    vertex_coordinates          = 0x00070000,   // GetVertexAMOModelMesh
    vertex_normals              = 0x00080000,   // GetNormalAMOModelMesh
    vertex_UVs                  = 0x000A0000,
    vertex_colors               = 0x000B0000,   // GetVertexColorAMOModelMesh
    vertex_groups               = 0x000C0000,   // GetWeightAMOModelMesh
    unused_unknown              = 0x000E0000,   // Never called by GetSubDataAMO, only present in st021
    mesh_attributes             = 0x000F0000,   // PlAMOGetModelAttributes
    bounding_box_size           = 0x00110000,   // bounding box size, used for stages
    material_properties         = 0x00000009,   // global
    texture_properties          = 0x0000000A
};

struct VectorXY {
    float x;
    float y;
};

struct VectorXYZ {
    float x;
    float y;
    float z;
};

struct VectorXYZW {
    float x;
    float y;
    float z;
    float w;
};


struct SectorHead {
    u32 magic;
    u32 data_count;
    u32 sector_size;
};


struct VertexIndex {
    u16 vertex_index;
    u16 cull_flag; // unused
};

struct TriStripIndex{
    u32 count;
    VertexIndex indices[count];
};

struct TriStripList{
    SectorHead header;
    TriStripIndex triangle_strip[header.data_count];
};

struct VertexGroupEntry{
    u32 bone_index;
    float weight;
};

struct VertexGroup{
    u32 influence_count;
    VertexGroupEntry influencing_bones[influence_count];
};

struct MeshAttributes{
    u32 amo_render_distance;
    u32 amo_unknown_0x10;
    u32 amo_unknown_0x14;
    u32 amo_culling;
    u32 amo_scissor;
    u32 amo_light;
    u32 amo_unknown_0x24;
    u32 amo_uv_scroll;
    u32 amo_unknown_0x2c;
    u32 amo_fade_color;
    u32 amo_special;
    u32 amo_unknown_0x38;
    u32 amo_unknown_0x3c;
    u32 amo_unknown_0x40;
    u32 amo_unknown_0x44;
    u32 amo_unknown_0x48;
    u32 amo_unknown_0x4c;
    u32 amo_unknown_0x50;
};

struct MeshData {
    SectorHead header;
    match (header.magic) {
        (SectorMagic::tristrip_container) : {
            TriStripList triangle_strip_list[header.data_count];
        }
        
        (SectorMagic::mesh_material_list) : {
            u32 material_index[header.data_count];
        }
        
        (SectorMagic::mesh_material_per_strip) : {
            u32 materials_per_tristrip[header.data_count];
        }
        
        (SectorMagic::vertex_coordinates) : {
            VectorXYZ vertex_coordinates[header.data_count];
        }
        
        (SectorMagic::vertex_normals) : {
            VectorXYZ vertex_normals[header.data_count];
        }
        
        (SectorMagic::vertex_UVs) : {
            VectorXY vertex_UVs[header.data_count];
        }
        
        (SectorMagic::vertex_colors) : {
            VectorXYZW vertex_colors[header.data_count];
        }
        
        (SectorMagic::vertex_groups) : {
            VertexGroup vertex_groups[header.data_count];
        }
        
        (SectorMagic::mesh_attributes) : {
            MeshAttributes attributes[header.data_count];
        }
        
        (SectorMagic::bounding_box_size) : {
            VectorXYZW bounding_box[header.data_count];
        }
    }
};

struct MeshEntry {
    SectorHead header;
    MeshData sector[header.data_count];
};

struct ModelContainer {
    SectorHead container_header;
    MeshEntry mesh_entries[container_header.data_count];
};

struct MaterialEntry {
    SectorHead header;
    VectorXYZW color[3];// unused
    float unknown_float;
    u32 unknown_u32;
    padding[0xC8];
    u32 texture_entry_index;
};

struct TextureEntry {
    SectorHead header;
    u32 TXB_texture_index;
    u32 width;
    u32 height;
    padding[0xF4];
};

struct MaterialList {
    SectorHead material_list_header;
    MaterialEntry material_entries[material_list_header.data_count];
};

struct TextureList {
    SectorHead texture_list_header;
    TextureEntry texture_entries[texture_list_header.data_count];
};

struct Entry {
    ModelContainer model_container;
    MaterialList material_list;
    TextureList texture_list;
};

Entry Entry @ 0x1C;
