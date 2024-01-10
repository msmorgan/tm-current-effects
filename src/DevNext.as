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
    "2023-12-21_23_50"  // released 2024-01-09
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
                        RenderVisApiValues(Vis);
                        UI::Text("error: " + getExceptionInfo());

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
    valuePairs.InsertLast({"AirBrakeNormed",          Round(    Vis.AsyncState.AirBrakeNormed)});
    valuePairs.InsertLast({"BulletTimeNormed",        Round(    Vis.AsyncState.BulletTimeNormed)});
    valuePairs.InsertLast({"EngineOn",                Round(    Vis.AsyncState.EngineOn)});
    // valuePairs.InsertLast({"CamGrpStates",            tostring( Vis.AsyncState.CamGrpStates)});
    valuePairs.InsertLast({"CamGrpStates",            "unknown new type"});
    valuePairs.InsertLast({"CurGear",                 RoundUint(Vis.AsyncState.CurGear)});
    valuePairs.InsertLast({"Dir",                     Round(    Vis.AsyncState.Dir)});
    valuePairs.InsertLast({"DiscontinuityCount",      RoundUint(Vis.AsyncState.DiscontinuityCount)});
    valuePairs.InsertLast({"FLBreakNormedCoef",       Round(    Vis.AsyncState.FLBreakNormedCoef)});
    valuePairs.InsertLast({"FLDamperLen",             Round(    Vis.AsyncState.FLDamperLen)});
    valuePairs.InsertLast({"FLGroundContactMaterial", tostring( Vis.AsyncState.FLGroundContactMaterial)});
    valuePairs.InsertLast({"FLIcing01",               Round(    Vis.AsyncState.FLIcing01)});
    valuePairs.InsertLast({"FLSlipCoef",              Round(    Vis.AsyncState.FLSlipCoef)});
    valuePairs.InsertLast({"FLSteerAngle",            Round(    Vis.AsyncState.FLSteerAngle)});
    valuePairs.InsertLast({"FLTireWear01",            Round(    Vis.AsyncState.FLTireWear01)});
    valuePairs.InsertLast({"FLWheelRot",              Round(    Vis.AsyncState.FLWheelRot)});
    valuePairs.InsertLast({"FLWheelRotSpeed",         Round(    Vis.AsyncState.FLWheelRotSpeed)});
    valuePairs.InsertLast({"FRBreakNormedCoef",       Round(    Vis.AsyncState.FRBreakNormedCoef)});
    valuePairs.InsertLast({"FRDamperLen",             Round(    Vis.AsyncState.FRDamperLen)});
    valuePairs.InsertLast({"FRGroundContactMaterial", tostring( Vis.AsyncState.FRGroundContactMaterial)});
    valuePairs.InsertLast({"FRIcing01",               Round(    Vis.AsyncState.FRIcing01)});
    valuePairs.InsertLast({"FRSlipCoef",              Round(    Vis.AsyncState.FRSlipCoef)});
    valuePairs.InsertLast({"FRSteerAngle",            Round(    Vis.AsyncState.FRSteerAngle)});
    valuePairs.InsertLast({"FrontSpeed",              Round(    Vis.AsyncState.FrontSpeed)});
    valuePairs.InsertLast({"FRTireWear01",            Round(    Vis.AsyncState.FRTireWear01)});
    valuePairs.InsertLast({"FRWheelRot",              Round(    Vis.AsyncState.FRWheelRot)});
    valuePairs.InsertLast({"FRWheelRotSpeed",         Round(    Vis.AsyncState.FRWheelRotSpeed)});
    valuePairs.InsertLast({"GroundDist",              Round(    Vis.AsyncState.GroundDist)});
    valuePairs.InsertLast({"InputBrakePedal",         Round(    Vis.AsyncState.InputBrakePedal)});
    valuePairs.InsertLast({"InputGasPedal",           Round(    Vis.AsyncState.InputGasPedal)});
    valuePairs.InsertLast({"InputIsBraking",          Round(    Vis.AsyncState.InputIsBraking)});
    valuePairs.InsertLast({"InputSteer",              Round(    Vis.AsyncState.InputSteer)});
    valuePairs.InsertLast({"InputVertical",           Round(    Vis.AsyncState.InputVertical)});
    valuePairs.InsertLast({"IsGroundContact",         Round(    Vis.AsyncState.IsGroundContact)});
    valuePairs.InsertLast({"IsReactorGroundMode",     Round(    Vis.AsyncState.IsReactorGroundMode)});
    valuePairs.InsertLast({"IsTopContact",            Round(    Vis.AsyncState.IsTopContact)});
    valuePairs.InsertLast({"IsTurbo",                 Round(    Vis.AsyncState.IsTurbo)});
    valuePairs.InsertLast({"IsWheelsBurning",         Round(    Vis.AsyncState.IsWheelsBurning)});
    valuePairs.InsertLast({"Left",                    Round(    Vis.AsyncState.Left)});
    valuePairs.InsertLast({"Position",                Round(    Vis.AsyncState.Position)});
    valuePairs.InsertLast({"RaceStartTime",           RoundUint(Vis.AsyncState.RaceStartTime)});
    valuePairs.InsertLast({"ReactorAirControl",       Round(    Vis.AsyncState.ReactorAirControl)});
    valuePairs.InsertLast({"ReactorBoostLvl",         tostring( Vis.AsyncState.ReactorBoostLvl)});
    valuePairs.InsertLast({"ReactorBoostType",        tostring( Vis.AsyncState.ReactorBoostType)});
    valuePairs.InsertLast({"ReactorInputsX",          Round(    Vis.AsyncState.ReactorInputsX)});
    valuePairs.InsertLast({"RLBreakNormedCoef",       Round(    Vis.AsyncState.RLBreakNormedCoef)});
    valuePairs.InsertLast({"RLDamperLen",             Round(    Vis.AsyncState.RLDamperLen)});
    valuePairs.InsertLast({"RLGroundContactMaterial", tostring( Vis.AsyncState.RLGroundContactMaterial)});
    valuePairs.InsertLast({"RLIcing01",               Round(    Vis.AsyncState.RLIcing01)});
    valuePairs.InsertLast({"RLSlipCoef",              Round(    Vis.AsyncState.RLSlipCoef)});
    valuePairs.InsertLast({"RLSteerAngle",            Round(    Vis.AsyncState.RLSteerAngle)});
    valuePairs.InsertLast({"RLTireWear01",            Round(    Vis.AsyncState.RLTireWear01)});
    valuePairs.InsertLast({"RLWheelRot",              Round(    Vis.AsyncState.RLWheelRot)});
    valuePairs.InsertLast({"RLWheelRotSpeed",         Round(    Vis.AsyncState.RLWheelRotSpeed)});
    valuePairs.InsertLast({"RRBreakNormedCoef",       Round(    Vis.AsyncState.RRBreakNormedCoef)});
    valuePairs.InsertLast({"RRDamperLen",             Round(    Vis.AsyncState.RRDamperLen)});
    valuePairs.InsertLast({"RRGroundContactMaterial", tostring( Vis.AsyncState.RRGroundContactMaterial)});
    valuePairs.InsertLast({"RRIcing01",               Round(    Vis.AsyncState.RRIcing01)});
    valuePairs.InsertLast({"RRSlipCoef",              Round(    Vis.AsyncState.RRSlipCoef)});
    valuePairs.InsertLast({"RRSteerAngle",            Round(    Vis.AsyncState.RRSteerAngle)});
    valuePairs.InsertLast({"RRTireWear01",            Round(    Vis.AsyncState.RRTireWear01)});
    valuePairs.InsertLast({"RRWheelRot",              Round(    Vis.AsyncState.RRWheelRot)});
    valuePairs.InsertLast({"RRWheelRotSpeed",         Round(    Vis.AsyncState.RRWheelRotSpeed)});
    valuePairs.InsertLast({"SimulationTimeCoef",      Round(    Vis.AsyncState.SimulationTimeCoef)});
    valuePairs.InsertLast({"SpoilerOpenNormed",       Round(    Vis.AsyncState.SpoilerOpenNormed)});
    valuePairs.InsertLast({"Turbo",                   Round(    Vis.Turbo)});
    valuePairs.InsertLast({"TurboTime",               Round(    Vis.AsyncState.TurboTime)});
    valuePairs.InsertLast({"Up",                      Round(    Vis.AsyncState.Up)});
    valuePairs.InsertLast({"WaterImmersionCoef",      Round(    Vis.AsyncState.WaterImmersionCoef)});
    valuePairs.InsertLast({"WaterOverDistNormed",     Round(    Vis.AsyncState.WaterOverDistNormed)});
    valuePairs.InsertLast({"WaterOverSurfacePos",     Round(    Vis.AsyncState.WaterOverSurfacePos)});
    valuePairs.InsertLast({"WetnessValue01",          Round(    Vis.AsyncState.WetnessValue01)});
    valuePairs.InsertLast({"WingsOpenNormed",         Round(    Vis.AsyncState.WingsOpenNormed)});
    valuePairs.InsertLast({"WorldCarUp",              Round(    Vis.AsyncState.WorldCarUp)});
    valuePairs.InsertLast({"WorldVel",                Round(    Vis.AsyncState.WorldVel)});

    if (UI::BeginTable("##api-val-table", 2, UI::TableFlags::ScrollY)) {
        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable");
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(valuePairs.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(valuePairs[i][0]);
                UI::TableNextColumn(); UI::Text(valuePairs[i][1]);
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