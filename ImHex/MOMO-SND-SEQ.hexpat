u32 seqOffset @0x18;


struct SampleData
{
    u8 SampleIndex; //based on SmplSCEI
    u8 Volume; // each increment is +25.6k samples on playback (?)
};


struct SequenceData
{
    SampleData Samples[4];
    s8 DelayTilNextSeq;
    u8 DelayMultiplier;
    SampleData ExtraSample;
    u8 unknown[8];
};


struct SequenceList
{
    u16 Offset;
    u16 Unknown;
};


struct TseqTSDR
{
    char Tag[8];
    u32 ChunkSize;
    u16 unknown;
    u16 Count;
    SequenceList SequenceList[Count];
    SequenceData SequenceData[Count];
};


TseqTSDR sequence @ seqOffset;
