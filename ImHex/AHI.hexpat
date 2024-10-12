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

struct RootTree{
    SectorHead header;
    u32 root_bone[header.data_count];
};

struct Bone{
    SectorHead header;
    s32 bone_id;
    s32 parent_index;
    s32 child_index;
    s32 unknown;
    VectorXYZW size; // used by shadow caster meshes only
    VectorXYZW rotation;
    VectorXYZW position;
    s32 constrained_mesh_index;
    padding[header.sector_size-0x50];
};

SectorHead main_header @ 0x0;
RootTree root_tree_list @ 0x0C;
Bone bone[main_header.data_count-1] @ 0x1C;