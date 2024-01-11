// c 2024-01-09
// m 2024-01-10

#if SIG_DEVELOPER && TMNEXT

bool   gameVersionValid = false;
string version;

// offsets for which a value is known
const int[] knownVisOffsets = {
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
const int[] observedVisOffsets = {
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
            UI::TextWrapped(RED + "Game version " + version + " not marked valid! Values may be wrong.");

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
    UI::TextWrapped("Most values are from CSceneVehicleVisState, which is inside CSceneVehicleVis.");

    string[][] valuePairs;
    valuePairs.InsertLast({"AirBrakeNormed",          "Float",   Round(    Vis.AsyncState.AirBrakeNormed)});
    valuePairs.InsertLast({"BulletTimeNormed",        "Float",   Round(    Vis.AsyncState.BulletTimeNormed)});
    valuePairs.InsertLast({"EngineOn",                "Bool",    Round(    Vis.AsyncState.EngineOn)});
    valuePairs.InsertLast({"CamGrpStates",            "Unknown", "unknown new type"});
    valuePairs.InsertLast({"CurGear",                 "Uint",    RoundUint(Vis.AsyncState.CurGear)});
    valuePairs.InsertLast({"Dir",                     "Vec3",    Round(    Vis.AsyncState.Dir)});
    valuePairs.InsertLast({"DiscontinuityCount",      "Uint8",   RoundUint(Vis.AsyncState.DiscontinuityCount)});
    valuePairs.InsertLast({"FLBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.FLBreakNormedCoef)});
    valuePairs.InsertLast({"FLDamperLen",             "Float",   Round(    Vis.AsyncState.FLDamperLen)});
    valuePairs.InsertLast({"FLGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.FLGroundContactMaterial)});
    valuePairs.InsertLast({"FLIcing01",               "Float",   Round(    Vis.AsyncState.FLIcing01)});
    valuePairs.InsertLast({"FLSlipCoef",              "Float",   Round(    Vis.AsyncState.FLSlipCoef)});
    valuePairs.InsertLast({"FLSteerAngle",            "Float",   Round(    Vis.AsyncState.FLSteerAngle)});
    valuePairs.InsertLast({"FLTireWear01",            "Float",   Round(    Vis.AsyncState.FLTireWear01)});
    valuePairs.InsertLast({"FLWheelRot",              "Float",   Round(    Vis.AsyncState.FLWheelRot)});
    valuePairs.InsertLast({"FLWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.FLWheelRotSpeed)});
    valuePairs.InsertLast({"FRBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.FRBreakNormedCoef)});
    valuePairs.InsertLast({"FRDamperLen",             "Float",   Round(    Vis.AsyncState.FRDamperLen)});
    valuePairs.InsertLast({"FRGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.FRGroundContactMaterial)});
    valuePairs.InsertLast({"FRIcing01",               "Float",   Round(    Vis.AsyncState.FRIcing01)});
    valuePairs.InsertLast({"FRSlipCoef",              "Float",   Round(    Vis.AsyncState.FRSlipCoef)});
    valuePairs.InsertLast({"FRSteerAngle",            "Float",   Round(    Vis.AsyncState.FRSteerAngle)});
    valuePairs.InsertLast({"FrontSpeed",              "Float",   Round(    Vis.AsyncState.FrontSpeed)});
    valuePairs.InsertLast({"FRTireWear01",            "Float",   Round(    Vis.AsyncState.FRTireWear01)});
    valuePairs.InsertLast({"FRWheelRot",              "Float",   Round(    Vis.AsyncState.FRWheelRot)});
    valuePairs.InsertLast({"FRWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.FRWheelRotSpeed)});
    valuePairs.InsertLast({"GroundDist",              "Float",   Round(    Vis.AsyncState.GroundDist)});
    valuePairs.InsertLast({"InputBrakePedal",         "Float",   Round(    Vis.AsyncState.InputBrakePedal)});
    valuePairs.InsertLast({"InputGasPedal",           "Float",   Round(    Vis.AsyncState.InputGasPedal)});
    valuePairs.InsertLast({"InputIsBraking",          "Bool",    Round(    Vis.AsyncState.InputIsBraking)});
    valuePairs.InsertLast({"InputSteer",              "Float",   Round(    Vis.AsyncState.InputSteer)});
    valuePairs.InsertLast({"InputVertical",           "Float",   Round(    Vis.AsyncState.InputVertical)});
    valuePairs.InsertLast({"IsGroundContact",         "Bool",    Round(    Vis.AsyncState.IsGroundContact)});
    valuePairs.InsertLast({"IsReactorGroundMode",     "Bool",    Round(    Vis.AsyncState.IsReactorGroundMode)});
    valuePairs.InsertLast({"IsTopContact",            "Bool",    Round(    Vis.AsyncState.IsTopContact)});
    valuePairs.InsertLast({"IsTurbo",                 "Bool",    Round(    Vis.AsyncState.IsTurbo)});
    valuePairs.InsertLast({"IsWheelsBurning",         "Bool",    Round(    Vis.AsyncState.IsWheelsBurning)});
    valuePairs.InsertLast({"Left",                    "Vec3",    Round(    Vis.AsyncState.Left)});
    valuePairs.InsertLast({"Position",                "Vec3",    Round(    Vis.AsyncState.Position)});
    valuePairs.InsertLast({"RaceStartTime",           "uint",    RoundUint(Vis.AsyncState.RaceStartTime)});
    valuePairs.InsertLast({"ReactorAirControl",       "Vec3",    Round(    Vis.AsyncState.ReactorAirControl)});
    valuePairs.InsertLast({"ReactorBoostLvl",         "Enum",    tostring( Vis.AsyncState.ReactorBoostLvl)});
    valuePairs.InsertLast({"ReactorBoostType",        "Enum",    tostring( Vis.AsyncState.ReactorBoostType)});
    valuePairs.InsertLast({"ReactorInputsX",          "Bool",    Round(    Vis.AsyncState.ReactorInputsX)});
    valuePairs.InsertLast({"RLBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.RLBreakNormedCoef)});
    valuePairs.InsertLast({"RLDamperLen",             "Float",   Round(    Vis.AsyncState.RLDamperLen)});
    valuePairs.InsertLast({"RLGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.RLGroundContactMaterial)});
    valuePairs.InsertLast({"RLIcing01",               "Float",   Round(    Vis.AsyncState.RLIcing01)});
    valuePairs.InsertLast({"RLSlipCoef",              "Float",   Round(    Vis.AsyncState.RLSlipCoef)});
    valuePairs.InsertLast({"RLSteerAngle",            "Float",   Round(    Vis.AsyncState.RLSteerAngle)});
    valuePairs.InsertLast({"RLTireWear01",            "Float",   Round(    Vis.AsyncState.RLTireWear01)});
    valuePairs.InsertLast({"RLWheelRot",              "Float",   Round(    Vis.AsyncState.RLWheelRot)});
    valuePairs.InsertLast({"RLWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.RLWheelRotSpeed)});
    valuePairs.InsertLast({"RRBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.RRBreakNormedCoef)});
    valuePairs.InsertLast({"RRDamperLen",             "Float",   Round(    Vis.AsyncState.RRDamperLen)});
    valuePairs.InsertLast({"RRGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.RRGroundContactMaterial)});
    valuePairs.InsertLast({"RRIcing01",               "Float",   Round(    Vis.AsyncState.RRIcing01)});
    valuePairs.InsertLast({"RRSlipCoef",              "Float",   Round(    Vis.AsyncState.RRSlipCoef)});
    valuePairs.InsertLast({"RRSteerAngle",            "Float",   Round(    Vis.AsyncState.RRSteerAngle)});
    valuePairs.InsertLast({"RRTireWear01",            "Float",   Round(    Vis.AsyncState.RRTireWear01)});
    valuePairs.InsertLast({"RRWheelRot",              "Float",   Round(    Vis.AsyncState.RRWheelRot)});
    valuePairs.InsertLast({"RRWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.RRWheelRotSpeed)});
    valuePairs.InsertLast({"SimulationTimeCoef",      "Float",   Round(    Vis.AsyncState.SimulationTimeCoef)});
    valuePairs.InsertLast({"SpoilerOpenNormed",       "Float",   Round(    Vis.AsyncState.SpoilerOpenNormed)});
    valuePairs.InsertLast({"Turbo",                   "Float",   Round(    Vis.Turbo)});
    valuePairs.InsertLast({"TurboTime",               "Float",   Round(    Vis.AsyncState.TurboTime)});
    valuePairs.InsertLast({"Up",                      "Vec3",    Round(    Vis.AsyncState.Up)});
    valuePairs.InsertLast({"WaterImmersionCoef",      "Float",   Round(    Vis.AsyncState.WaterImmersionCoef)});
    valuePairs.InsertLast({"WaterOverDistNormed",     "Float",   Round(    Vis.AsyncState.WaterOverDistNormed)});
    valuePairs.InsertLast({"WaterOverSurfacePos",     "Vec3",    Round(    Vis.AsyncState.WaterOverSurfacePos)});
    valuePairs.InsertLast({"WetnessValue01",          "Float",   Round(    Vis.AsyncState.WetnessValue01)});
    valuePairs.InsertLast({"WingsOpenNormed",         "Float",   Round(    Vis.AsyncState.WingsOpenNormed)});
    valuePairs.InsertLast({"WorldCarUp",              "Vec3",    Round(    Vis.AsyncState.WorldCarUp)});
    valuePairs.InsertLast({"WorldVel",                "Vec3",    Round(    Vis.AsyncState.WorldVel)});

    if (UI::BeginTable("##vis-api-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type", UI::TableColumnFlags::WidthFixed, 90.0f);
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

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderVisOffsetValues(CSceneVehicleVis@ Vis) {
    ;
}

void RenderVisOffsets(CSceneVehicleVis@ Vis) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::Text("CSceneVehicleVisState starts at offset ___ (0x___)");

    if (UI::BeginTable("##vis-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();
    }

    UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
    while (clipper.Step()) {
        for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
            int offset = i * S_OffsetSkip;
            string color = knownVisOffsets.Find(offset) > -1 ? "" : (observedVisOffsets.Find(offset) > -1) ? YELLOW : RED;

            UI::TableNextRow();
            UI::TableNextColumn();
            UI::Text(color + offset);

            UI::TableNextColumn();
            UI::Text(color + "0x" + Text::Format("%X", offset));

            UI::TableNextColumn();
            try {
                switch (S_OffsetType) {
                    case DataType::Int8:   UI::Text(Round(    Dev::GetOffsetInt8  (Vis, offset))); break;
                    case DataType::Uint8:  UI::Text(RoundUint(Dev::GetOffsetUint8 (Vis, offset))); break;
                    case DataType::Int16:  UI::Text(Round(    Dev::GetOffsetInt16 (Vis, offset))); break;
                    case DataType::Uint16: UI::Text(RoundUint(Dev::GetOffsetUint16(Vis, offset))); break;
                    case DataType::Int32:  UI::Text(Round(    Dev::GetOffsetInt32 (Vis, offset))); break;
                    case DataType::Uint32: UI::Text(RoundUint(Dev::GetOffsetUint32(Vis, offset))); break;
                    case DataType::Int64:  UI::Text(Round(    Dev::GetOffsetInt64 (Vis, offset))); break;
                    case DataType::Uint64: UI::Text(RoundUint(Dev::GetOffsetUint64(Vis, offset))); break;
                    case DataType::Float:  UI::Text(Round(    Dev::GetOffsetFloat (Vis, offset))); break;
                    case DataType::Vec3:   UI::Text(Round(    Dev::GetOffsetVec3  (Vis, offset))); break;
                    case DataType::Iso4:   UI::Text(Round(    Dev::GetOffsetIso4  (Vis, offset))); break;
                    default:;
                }
            } catch {
                UI::Text(YELLOW + getExceptionInfo());
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

#endif