// c 2024-01-09
// m 2024-01-10

#if SIG_DEVELOPER && TMNEXT

bool   gameVersionValid = false;
string version;

// offsets for which a value is known
const int[] knownVisoffets = {
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
const int[] observedVisOffets = {
};

// game versions for which the offsets in this file are valid
const string[] validGameVersions = {
    "2024-01-10_12_53"  // released 2024-01-10
};

void InitDevNext() {
    version = GetApp().SystemPlatform.ExeVersion;
    gameVersionValid = validGameVersions.Find(version) > -1;
}

void RenderDevNext() {
    if (!S_Dev || version.Length == 0)
        return;

    UI::Begin(titleDev, S_Dev, UI::WindowFlags::None);
        if (!gameVersionValid)
            UI::Text(RED + "Game version " + version + " not marked valid! Values may be wrong.");

        UI::BeginTabBar("##dev-tabs");
            Tab_Vis();
        UI::EndTabBar();
    UI::End();
}

void Tab_Vis() {
    if (!UI::BeginTabItem("CSceneVehicleVis"))
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
    if (Playground is null) {
        UI::Text(RED + "null Playground");
        UI::EndTabItem();
        return;
    }

    ISceneVis@ Scene = cast<ISceneVis@>(App.GameScene);
    if (Scene is null) {
        UI::Text(RED + "null Scene");
        UI::EndTabItem();
        return;
    }

    UI::BeginTabBar("##vis-tabs");
        bool meExists = false;

        CSceneVehicleVis@[] AllVis = VehicleState::GetAllVis(Scene);
        CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
        CSceneVehicleVis@ MyVis = Player !is null ? VehicleState::GetVis(Scene, Player) : VehicleState::GetSingularVis(Scene);
        if (MyVis !is null) {
            AllVis.InsertAt(0, MyVis);
            meExists = true;
        }

        for (uint i = 0; i < AllVis.Length; i++) {
            CSceneVehicleVis@ Vis = AllVis[i];

            if (UI::BeginTabItem(i == 0 && meExists ? Icons::User + " Me" : i + "_" + Vis.Model.Id.GetName())) {
                UI::BeginTabBar("##vis-tabs-single");

                    if (UI::BeginTabItem("API Values")) {
                        try   { RenderVisApiValues(Vis); }
                        catch { UI::Text("error: " + getExceptionInfo()); }

                        UI::EndTabItem();
                    }

                    if (UI::BeginTabItem("Offset Values")) {
                        try   { RenderVisOffsetValues(Vis); }
                        catch { UI::Text("error: " + getExceptionInfo()); }

                        UI::EndTabItem();
                    }

                    if (UI::BeginTabItem("Offsets")) {
                        try   { RenderVisOffsets(Vis); }
                        catch { UI::Text("error: " + getExceptionInfo()); }

                        UI::EndTabItem();
                    }

                UI::EndTabBar();
                UI::EndTabItem();
            }
        }

    UI::EndTabBar();
    UI::EndTabItem();
}

void RenderVisApiValues(CSceneVehicleVis@ Vis) {
    UI::Text("Most values are from CSceneVehicleVisState, which is inside CSceneVehicleVis.");

    string[][] valuePairs;
    valuePairs.InsertLast({"AirBrakeNormed",          "float",   Round(    Vis.AsyncState.AirBrakeNormed)});
    valuePairs.InsertLast({"BulletTimeNormed",        "float",   Round(    Vis.AsyncState.BulletTimeNormed)});
    valuePairs.InsertLast({"EngineOn",                "bool",    Round(    Vis.AsyncState.EngineOn)});
    valuePairs.InsertLast({"CamGrpStates",            "unknown", "unknown new type"});
    valuePairs.InsertLast({"CurGear",                 "uint",    RoundUint(Vis.AsyncState.CurGear)});
    valuePairs.InsertLast({"Dir",                     "vec3",    Round(    Vis.AsyncState.Dir)});
    valuePairs.InsertLast({"DiscontinuityCount",      "uint8",   RoundUint(Vis.AsyncState.DiscontinuityCount)});
    valuePairs.InsertLast({"FLBreakNormedCoef",       "float",   Round(    Vis.AsyncState.FLBreakNormedCoef)});
    valuePairs.InsertLast({"FLDamperLen",             "float",   Round(    Vis.AsyncState.FLDamperLen)});
    valuePairs.InsertLast({"FLGroundContactMaterial", "enum",    tostring( Vis.AsyncState.FLGroundContactMaterial)});
    valuePairs.InsertLast({"FLIcing01",               "float",   Round(    Vis.AsyncState.FLIcing01)});
    valuePairs.InsertLast({"FLSlipCoef",              "float",   Round(    Vis.AsyncState.FLSlipCoef)});
    valuePairs.InsertLast({"FLSteerAngle",            "float",   Round(    Vis.AsyncState.FLSteerAngle)});
    valuePairs.InsertLast({"FLTireWear01",            "float",   Round(    Vis.AsyncState.FLTireWear01)});
    valuePairs.InsertLast({"FLWheelRot",              "float",   Round(    Vis.AsyncState.FLWheelRot)});
    valuePairs.InsertLast({"FLWheelRotSpeed",         "float",   Round(    Vis.AsyncState.FLWheelRotSpeed)});
    valuePairs.InsertLast({"FRBreakNormedCoef",       "float",   Round(    Vis.AsyncState.FRBreakNormedCoef)});
    valuePairs.InsertLast({"FRDamperLen",             "float",   Round(    Vis.AsyncState.FRDamperLen)});
    valuePairs.InsertLast({"FRGroundContactMaterial", "enum",    tostring( Vis.AsyncState.FRGroundContactMaterial)});
    valuePairs.InsertLast({"FRIcing01",               "float",   Round(    Vis.AsyncState.FRIcing01)});
    valuePairs.InsertLast({"FRSlipCoef",              "float",   Round(    Vis.AsyncState.FRSlipCoef)});
    valuePairs.InsertLast({"FRSteerAngle",            "float",   Round(    Vis.AsyncState.FRSteerAngle)});
    valuePairs.InsertLast({"FrontSpeed",              "float",   Round(    Vis.AsyncState.FrontSpeed)});
    valuePairs.InsertLast({"FRTireWear01",            "float",   Round(    Vis.AsyncState.FRTireWear01)});
    valuePairs.InsertLast({"FRWheelRot",              "float",   Round(    Vis.AsyncState.FRWheelRot)});
    valuePairs.InsertLast({"FRWheelRotSpeed",         "float",   Round(    Vis.AsyncState.FRWheelRotSpeed)});
    valuePairs.InsertLast({"GroundDist",              "float",   Round(    Vis.AsyncState.GroundDist)});
    valuePairs.InsertLast({"InputBrakePedal",         "float",   Round(    Vis.AsyncState.InputBrakePedal)});
    valuePairs.InsertLast({"InputGasPedal",           "float",   Round(    Vis.AsyncState.InputGasPedal)});
    valuePairs.InsertLast({"InputIsBraking",          "bool",    Round(    Vis.AsyncState.InputIsBraking)});
    valuePairs.InsertLast({"InputSteer",              "float",   Round(    Vis.AsyncState.InputSteer)});
    valuePairs.InsertLast({"InputVertical",           "float",   Round(    Vis.AsyncState.InputVertical)});
    valuePairs.InsertLast({"IsGroundContact",         "bool",    Round(    Vis.AsyncState.IsGroundContact)});
    valuePairs.InsertLast({"IsReactorGroundMode",     "bool",    Round(    Vis.AsyncState.IsReactorGroundMode)});
    valuePairs.InsertLast({"IsTopContact",            "bool",    Round(    Vis.AsyncState.IsTopContact)});
    valuePairs.InsertLast({"IsTurbo",                 "bool",    Round(    Vis.AsyncState.IsTurbo)});
    valuePairs.InsertLast({"IsWheelsBurning",         "bool",    Round(    Vis.AsyncState.IsWheelsBurning)});
    valuePairs.InsertLast({"Left",                    "vec3",    Round(    Vis.AsyncState.Left)});
    valuePairs.InsertLast({"Position",                "vec3",    Round(    Vis.AsyncState.Position)});
    valuePairs.InsertLast({"RaceStartTime",           "uint",    RoundUint(Vis.AsyncState.RaceStartTime)});
    valuePairs.InsertLast({"ReactorAirControl",       "vec3",    Round(    Vis.AsyncState.ReactorAirControl)});
    valuePairs.InsertLast({"ReactorBoostLvl",         "enum",    tostring( Vis.AsyncState.ReactorBoostLvl)});
    valuePairs.InsertLast({"ReactorBoostType",        "enum",    tostring( Vis.AsyncState.ReactorBoostType)});
    valuePairs.InsertLast({"ReactorInputsX",          "bool",    Round(    Vis.AsyncState.ReactorInputsX)});
    valuePairs.InsertLast({"RLBreakNormedCoef",       "float",   Round(    Vis.AsyncState.RLBreakNormedCoef)});
    valuePairs.InsertLast({"RLDamperLen",             "float",   Round(    Vis.AsyncState.RLDamperLen)});
    valuePairs.InsertLast({"RLGroundContactMaterial", "enum",    tostring( Vis.AsyncState.RLGroundContactMaterial)});
    valuePairs.InsertLast({"RLIcing01",               "float",   Round(    Vis.AsyncState.RLIcing01)});
    valuePairs.InsertLast({"RLSlipCoef",              "float",   Round(    Vis.AsyncState.RLSlipCoef)});
    valuePairs.InsertLast({"RLSteerAngle",            "float",   Round(    Vis.AsyncState.RLSteerAngle)});
    valuePairs.InsertLast({"RLTireWear01",            "float",   Round(    Vis.AsyncState.RLTireWear01)});
    valuePairs.InsertLast({"RLWheelRot",              "float",   Round(    Vis.AsyncState.RLWheelRot)});
    valuePairs.InsertLast({"RLWheelRotSpeed",         "float",   Round(    Vis.AsyncState.RLWheelRotSpeed)});
    valuePairs.InsertLast({"RRBreakNormedCoef",       "float",   Round(    Vis.AsyncState.RRBreakNormedCoef)});
    valuePairs.InsertLast({"RRDamperLen",             "float",   Round(    Vis.AsyncState.RRDamperLen)});
    valuePairs.InsertLast({"RRGroundContactMaterial", "enum",    tostring( Vis.AsyncState.RRGroundContactMaterial)});
    valuePairs.InsertLast({"RRIcing01",               "float",   Round(    Vis.AsyncState.RRIcing01)});
    valuePairs.InsertLast({"RRSlipCoef",              "float",   Round(    Vis.AsyncState.RRSlipCoef)});
    valuePairs.InsertLast({"RRSteerAngle",            "float",   Round(    Vis.AsyncState.RRSteerAngle)});
    valuePairs.InsertLast({"RRTireWear01",            "float",   Round(    Vis.AsyncState.RRTireWear01)});
    valuePairs.InsertLast({"RRWheelRot",              "float",   Round(    Vis.AsyncState.RRWheelRot)});
    valuePairs.InsertLast({"RRWheelRotSpeed",         "float",   Round(    Vis.AsyncState.RRWheelRotSpeed)});
    valuePairs.InsertLast({"SimulationTimeCoef",      "float",   Round(    Vis.AsyncState.SimulationTimeCoef)});
    valuePairs.InsertLast({"SpoilerOpenNormed",       "float",   Round(    Vis.AsyncState.SpoilerOpenNormed)});
    valuePairs.InsertLast({"Turbo",                   "float",   Round(    Vis.Turbo)});
    valuePairs.InsertLast({"TurboTime",               "float",   Round(    Vis.AsyncState.TurboTime)});
    valuePairs.InsertLast({"Up",                      "vec3",    Round(    Vis.AsyncState.Up)});
    valuePairs.InsertLast({"WaterImmersionCoef",      "float",   Round(    Vis.AsyncState.WaterImmersionCoef)});
    valuePairs.InsertLast({"WaterOverDistNormed",     "float",   Round(    Vis.AsyncState.WaterOverDistNormed)});
    valuePairs.InsertLast({"WaterOverSurfacePos",     "vec3",    Round(    Vis.AsyncState.WaterOverSurfacePos)});
    valuePairs.InsertLast({"WetnessValue01",          "float",   Round(    Vis.AsyncState.WetnessValue01)});
    valuePairs.InsertLast({"WingsOpenNormed",         "float",   Round(    Vis.AsyncState.WingsOpenNormed)});
    valuePairs.InsertLast({"WorldCarUp",              "vec3",    Round(    Vis.AsyncState.WorldCarUp)});
    valuePairs.InsertLast({"WorldVel",                "vec3",    Round(    Vis.AsyncState.WorldVel)});

    if (UI::BeginTable("##api-val-table", 3, UI::TableFlags::ScrollY)) {
        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable");
        UI::TableSetupColumn("Type");
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(valuePairs.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(valuePairs[i][0]);
                UI::TableNextColumn(); UI::Text(valuePairs[i][1]);
                UI::TableNextColumn(); UI::Text(valuePairs[i][2]);
            }
        }

        UI::EndTable();
    }
}

void RenderVisOffsetValues(CSceneVehicleVis@ Vis) {
    ;
}

void RenderVisOffsets(CSceneVehicleVis@ Vis) {
    ;
}

#endif