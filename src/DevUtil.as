// c 2024-01-10
// m 2024-01-10

#if SIG_DEVELOPER && TMNEXT

const string BLUE   = "\\$09D";
const string CYAN   = "\\$2FF";
const string GRAY   = "\\$888";
const string GREEN  = "\\$0D2";
const string ORANGE = "\\$F90";
const string PURPLE = "\\$F0F";
const string RED    = "\\$F00";
const string WHITE  = "\\$FFF";
const string YELLOW = "\\$FF0";

enum DataType {
    Int8,
    Uint8,
    Int16,
    Uint16,
    Int32,
    Uint32,
    Int64,
    Uint64,
    Float,
    // Double,
    Vec2,
    Vec3,
    Vec4,
    // Iso3,
    Iso4,
    // Nat2,
    // Nat3,
    // String
}

string IntToHex(int i) {
    return "0x" + Text::Format("%X", i);
}

string Round(bool b) {
    return (b ? GREEN : RED) + b;
}

string Round(int num) {
    return (num == 0 ? WHITE : num < 0 ? RED : GREEN) + Math::Abs(num);
}

string Round(float num, uint precision = S_Precision) {
    return (num == 0 ? WHITE : num < 0 ? RED : GREEN) + Text::Format("%." + precision + "f", Math::Abs(num));
}

string Round(vec2 vec, uint precision = S_Precision) {
    return Round(vec.x, precision) + "\\$G , " + Round(vec.y, precision);
}

string Round(vec3 vec, uint precision = S_Precision) {
    return Round(vec.x, precision) + "\\$G , " + Round(vec.y, precision) + "\\$G , " + Round(vec.z, precision);
}

string Round(vec4 vec, uint precision = S_Precision) {
    return Round(vec.x, precision) + "\\$G , " + Round(vec.y, precision) + "\\$G , " + Round(vec.z, precision) + "\\$G , " + Round(vec.w, precision);
}

string Round(iso4 iso, uint precision = S_Precision) {
    string ret;

    ret += Round(iso.tx, precision) + "\\$G , " + Round(iso.ty, precision) + "\\$G , " + Round(iso.tz, precision) + "\n";
    ret += Round(iso.xx, precision) + "\\$G , " + Round(iso.xy, precision) + "\\$G , " + Round(iso.xz, precision) + "\n";
    ret += Round(iso.yx, precision) + "\\$G , " + Round(iso.yy, precision) + "\\$G , " + Round(iso.yz, precision) + "\n";
    ret += Round(iso.zx, precision) + "\\$G , " + Round(iso.zy, precision) + "\\$G , " + Round(iso.zz, precision);

    return ret;
}

string RoundUint(uint num) {  // separate function else a uint gets converted to an int, losing data
    return (num == 0 ? WHITE : GREEN) + num;
}

#endif