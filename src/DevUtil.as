// c 2024-01-10
// m 2024-01-10

#if SIG_DEVELOPER && TMNEXT

const string GREEN = "\\$0D2";
const string RED   = "\\$F00";
const string WHITE = "\\$FFF";

string Round(bool b) {
    return (b ? GREEN : RED) + b;
}

string Round(int num) {
    return (num == 0 ? WHITE : num < 0 ? RED : GREEN) + Math::Abs(num);
}

string Round(float num, uint precision = 3) {
    return (num == 0 ? WHITE : num < 0 ? RED : GREEN) + Text::Format("%." + precision + "f", Math::Abs(num));
}

string Round(vec3 vec, uint precision = 3) {
    return Round(vec.x, precision) + " , " + Round(vec.y, precision) + " , " + Round(vec.z, precision);
}

string Round(iso4 iso, uint precision = 3) {
    string ret;

    ret += Round(iso.tx, precision) + " , " + Round(iso.ty, precision) + " , " + Round(iso.tz, precision) + "\n";
    ret += Round(iso.xx, precision) + " , " + Round(iso.xy, precision) + " , " + Round(iso.xz, precision) + "\n";
    ret += Round(iso.yx, precision) + " , " + Round(iso.yy, precision) + " , " + Round(iso.yz, precision) + "\n";
    ret += Round(iso.zx, precision) + " , " + Round(iso.zy, precision) + " , " + Round(iso.zz, precision);

    return ret;
}

string RoundUint(uint num) {
    return (num == 0 ? WHITE : GREEN) + num;
}

#endif