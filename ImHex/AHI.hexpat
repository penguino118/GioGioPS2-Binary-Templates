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
    u32 root_bone_list[header.data_count];
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

struct BoneList {
    SectorHead main_header;
    RootTree root_bones_list;
    Bone bone_list[main_header.data_count-1];
};

BoneList AHI @ 0x0;
