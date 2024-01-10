// c 2024-01-09
// m 2024-01-10

#if SIG_DEVELOPER && TMNEXT

string version;

const string GREEN = "\\$0D2";
const string RED   = "\\$F00";
const string WHITE = "\\$FFF";

// offsets for which a value is known
int[] knownVisoffets = {
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
int[] observedVisOffets = {
};

// game versions for which the offsets in this file are valid
string[] validGameVersions = {
    "2023-12-21_23_50"  // released 2024-01-09
};

bool GoodGameVersion() {
    return version.Length > 0 && validGameVersions.Find(version) > -1;
}

void InitDevNext() {
    version = GetApp().SystemPlatform.ExeVersion;
}

void RenderDevNext() {
    if (!S_Dev || version.Length == 0)
        return;

    UI::Begin(titleDev, S_Dev, UI::WindowFlags::None);
    UI::BeginTabBar("##dev-tabs");
        Tab_CSceneVehicleVis();
    UI::EndTabBar();
    UI::End();
}

void Tab_CSceneVehicleVis() {
    if (!UI::BeginTabItem("CSceneVehicleVis"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    try {
        CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
        if (Playground is null)
            throw("null playground");

        ISceneVis@ Scene = cast<ISceneVis@>(App.GameScene);
        if (Scene is null)
            throw("null scene");

        UI::BeginTabBar("##vis-tabs");
            if (UI::BeginTabItem("Mine")) {
                try {
                    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);

                    CSceneVehicleVis@ Vis = Player !is null ? VehicleState::GetVis(Scene, Player) : VehicleState::GetSingularVis(Scene);
                    if (Vis is null)
                        throw("null vis");

                    UI::BeginTabBar("##vis-tabs-mine");
                        if (UI::BeginTabItem("Offsets")) {
                            try {
                                RenderVisOffsets(Vis);
                            } catch {
                                UI::Text("error: " + getExceptionInfo());
                            }

                            UI::EndTabItem();
                        }

                        if (UI::BeginTabItem("Values")) {
                            try {
                                RenderVisValues(Vis);
                            } catch {
                                UI::Text("error: " + getExceptionInfo());
                            }

                            UI::EndTabItem();
                        }
                    UI::EndTabBar();
                } catch {
                    UI::Text("error: " + getExceptionInfo());
                }
            }

            CSceneVehicleVis@[] allVis = VehicleState::GetAllVis(Scene);
            for (uint i = 0; i < allVis.Length; i++) {
                CSceneVehicleVis@ Vis = allVis[i];
                if (UI::BeginTabItem(i + "_" + Vis.Model.Id.GetName())) {
                    ;

                    UI::EndTabItem();
                }
            }
        UI::EndTabBar();
    } catch {
        UI::Text("error: " + getExceptionInfo());
    }

    UI::EndTabItem();
}

void RenderVisOffsets(CSceneVehicleVis@ Vis) {
    ;
}

void RenderVisValues(CSceneVehicleVis@ Vis) {
    ;
}

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