// c 2024-01-09
// m 2024-01-10

#if SIG_DEVELOPER && TMNEXT

bool   gameVersionValid = false;
string offsetSearch;
string version;

// offsets for which a value is known
const int[] knownVisOffsets = {
    348, 352, 356, 360, 364, 368, 376, 384, 388, 392, 396, 400, 404, 408, 412, 416, 544, 552, 560, 568, 580, 592, 664
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
const int[] observedVisOffsets = {
    124, 372, 548, 556, 564, 572, 576, 584, 588, 596
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

    string[][] values;
    values.InsertLast({"AirBrakeNormed",          "Float",   Round(    Vis.AsyncState.AirBrakeNormed)});
    values.InsertLast({"BulletTimeNormed",        "Float",   Round(    Vis.AsyncState.BulletTimeNormed)});
    values.InsertLast({"EngineOn",                "Bool",    Round(    Vis.AsyncState.EngineOn)});
    values.InsertLast({"CamGrpStates",            "Unknown", "unknown new type"});
    values.InsertLast({"CurGear",                 "Uint",    RoundUint(Vis.AsyncState.CurGear)});
    values.InsertLast({"Dir",                     "Vec3",    Round(    Vis.AsyncState.Dir)});
    values.InsertLast({"DiscontinuityCount",      "Uint8",   RoundUint(Vis.AsyncState.DiscontinuityCount)});
    values.InsertLast({"FLBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.FLBreakNormedCoef)});
    values.InsertLast({"FLDamperLen",             "Float",   Round(    Vis.AsyncState.FLDamperLen)});
    values.InsertLast({"FLGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.FLGroundContactMaterial)});
    values.InsertLast({"FLIcing01",               "Float",   Round(    Vis.AsyncState.FLIcing01)});
    values.InsertLast({"FLSlipCoef",              "Float",   Round(    Vis.AsyncState.FLSlipCoef)});
    values.InsertLast({"FLSteerAngle",            "Float",   Round(    Vis.AsyncState.FLSteerAngle)});
    values.InsertLast({"FLTireWear01",            "Float",   Round(    Vis.AsyncState.FLTireWear01)});
    values.InsertLast({"FLWheelRot",              "Float",   Round(    Vis.AsyncState.FLWheelRot)});
    values.InsertLast({"FLWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.FLWheelRotSpeed)});
    values.InsertLast({"FRBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.FRBreakNormedCoef)});
    values.InsertLast({"FRDamperLen",             "Float",   Round(    Vis.AsyncState.FRDamperLen)});
    values.InsertLast({"FRGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.FRGroundContactMaterial)});
    values.InsertLast({"FRIcing01",               "Float",   Round(    Vis.AsyncState.FRIcing01)});
    values.InsertLast({"FRSlipCoef",              "Float",   Round(    Vis.AsyncState.FRSlipCoef)});
    values.InsertLast({"FRSteerAngle",            "Float",   Round(    Vis.AsyncState.FRSteerAngle)});
    values.InsertLast({"FrontSpeed",              "Float",   Round(    Vis.AsyncState.FrontSpeed)});
    values.InsertLast({"FRTireWear01",            "Float",   Round(    Vis.AsyncState.FRTireWear01)});
    values.InsertLast({"FRWheelRot",              "Float",   Round(    Vis.AsyncState.FRWheelRot)});
    values.InsertLast({"FRWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.FRWheelRotSpeed)});
    values.InsertLast({"GroundDist",              "Float",   Round(    Vis.AsyncState.GroundDist)});
    values.InsertLast({"InputBrakePedal",         "Float",   Round(    Vis.AsyncState.InputBrakePedal)});
    values.InsertLast({"InputGasPedal",           "Float",   Round(    Vis.AsyncState.InputGasPedal)});
    values.InsertLast({"InputIsBraking",          "Bool",    Round(    Vis.AsyncState.InputIsBraking)});
    values.InsertLast({"InputSteer",              "Float",   Round(    Vis.AsyncState.InputSteer)});
    values.InsertLast({"InputVertical",           "Float",   Round(    Vis.AsyncState.InputVertical)});
    values.InsertLast({"IsGroundContact",         "Bool",    Round(    Vis.AsyncState.IsGroundContact)});
    values.InsertLast({"IsReactorGroundMode",     "Bool",    Round(    Vis.AsyncState.IsReactorGroundMode)});
    values.InsertLast({"IsTopContact",            "Bool",    Round(    Vis.AsyncState.IsTopContact)});
    values.InsertLast({"IsTurbo",                 "Bool",    Round(    Vis.AsyncState.IsTurbo)});
    values.InsertLast({"IsWheelsBurning",         "Bool",    Round(    Vis.AsyncState.IsWheelsBurning)});
    values.InsertLast({"Left",                    "Vec3",    Round(    Vis.AsyncState.Left)});
    values.InsertLast({"Position",                "Vec3",    Round(    Vis.AsyncState.Position)});
    values.InsertLast({"RaceStartTime",           "Uint",    RoundUint(Vis.AsyncState.RaceStartTime)});
    values.InsertLast({"ReactorAirControl",       "Vec3",    Round(    Vis.AsyncState.ReactorAirControl)});
    values.InsertLast({"ReactorBoostLvl",         "Enum",    tostring( Vis.AsyncState.ReactorBoostLvl)});
    values.InsertLast({"ReactorBoostType",        "Enum",    tostring( Vis.AsyncState.ReactorBoostType)});
    values.InsertLast({"ReactorInputsX",          "Bool",    Round(    Vis.AsyncState.ReactorInputsX)});
    values.InsertLast({"RLBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.RLBreakNormedCoef)});
    values.InsertLast({"RLDamperLen",             "Float",   Round(    Vis.AsyncState.RLDamperLen)});
    values.InsertLast({"RLGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.RLGroundContactMaterial)});
    values.InsertLast({"RLIcing01",               "Float",   Round(    Vis.AsyncState.RLIcing01)});
    values.InsertLast({"RLSlipCoef",              "Float",   Round(    Vis.AsyncState.RLSlipCoef)});
    values.InsertLast({"RLSteerAngle",            "Float",   Round(    Vis.AsyncState.RLSteerAngle)});
    values.InsertLast({"RLTireWear01",            "Float",   Round(    Vis.AsyncState.RLTireWear01)});
    values.InsertLast({"RLWheelRot",              "Float",   Round(    Vis.AsyncState.RLWheelRot)});
    values.InsertLast({"RLWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.RLWheelRotSpeed)});
    values.InsertLast({"RRBreakNormedCoef",       "Float",   Round(    Vis.AsyncState.RRBreakNormedCoef)});
    values.InsertLast({"RRDamperLen",             "Float",   Round(    Vis.AsyncState.RRDamperLen)});
    values.InsertLast({"RRGroundContactMaterial", "Enum",    tostring( Vis.AsyncState.RRGroundContactMaterial)});
    values.InsertLast({"RRIcing01",               "Float",   Round(    Vis.AsyncState.RRIcing01)});
    values.InsertLast({"RRSlipCoef",              "Float",   Round(    Vis.AsyncState.RRSlipCoef)});
    values.InsertLast({"RRSteerAngle",            "Float",   Round(    Vis.AsyncState.RRSteerAngle)});
    values.InsertLast({"RRTireWear01",            "Float",   Round(    Vis.AsyncState.RRTireWear01)});
    values.InsertLast({"RRWheelRot",              "Float",   Round(    Vis.AsyncState.RRWheelRot)});
    values.InsertLast({"RRWheelRotSpeed",         "Float",   Round(    Vis.AsyncState.RRWheelRotSpeed)});
    values.InsertLast({"SimulationTimeCoef",      "Float",   Round(    Vis.AsyncState.SimulationTimeCoef)});
    values.InsertLast({"SpoilerOpenNormed",       "Float",   Round(    Vis.AsyncState.SpoilerOpenNormed)});
    values.InsertLast({"Turbo",                   "Float",   Round(    Vis.Turbo)});
    values.InsertLast({"TurboTime",               "Float",   Round(    Vis.AsyncState.TurboTime)});
    values.InsertLast({"Up",                      "Vec3",    Round(    Vis.AsyncState.Up)});
    values.InsertLast({"WaterImmersionCoef",      "Float",   Round(    Vis.AsyncState.WaterImmersionCoef)});
    values.InsertLast({"WaterOverDistNormed",     "Float",   Round(    Vis.AsyncState.WaterOverDistNormed)});
    values.InsertLast({"WaterOverSurfacePos",     "Vec3",    Round(    Vis.AsyncState.WaterOverSurfacePos)});
    values.InsertLast({"WetnessValue01",          "Float",   Round(    Vis.AsyncState.WetnessValue01)});
    values.InsertLast({"WingsOpenNormed",         "Float",   Round(    Vis.AsyncState.WingsOpenNormed)});
    values.InsertLast({"WorldCarUp",              "Vec3",    Round(    Vis.AsyncState.WorldCarUp)});
    values.InsertLast({"WorldVel",                "Vec3",    Round(    Vis.AsyncState.WorldVel)});

    if (UI::BeginTable("##vis-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Variable", UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type",     UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);
                UI::TableNextColumn(); UI::Text(values[i][2]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

void RenderVisOffsetValues(CSceneVehicleVis@ Vis) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");

    string[][] values;
    values.InsertLast(VisOffsetValue(Vis, 348, "Position",          DataType::Vec3));
    values.InsertLast(VisOffsetValue(Vis, 360, "WorldVel",          DataType::Vec3));
    values.InsertLast(VisOffsetValue(Vis, 376, "IsWheelsBurning",   DataType::Bool));
    values.InsertLast(VisOffsetValue(Vis, 384, "FLIcing01",         DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 388, "FRIcing01",         DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 392, "RRIcing01",         DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 396, "RLIcing01",         DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 400, "FLSlipCoef",        DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 404, "FRSlipCoef",        DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 408, "RRSlipCoef",        DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 412, "RLSlipCoef",        DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 416, "InputGasPedal",     DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 544, "InputIsBraking",    DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 548, "BrakingCoefStrong", DataType::Float, false));
    values.InsertLast(VisOffsetValue(Vis, 552, "HasReactor",        DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 556, "Reactor???",        DataType::Float, false));
    values.InsertLast(VisOffsetValue(Vis, 560, "HasYellowReactor",  DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 564, "YellowReactor???",  DataType::Float, false));
    values.InsertLast(VisOffsetValue(Vis, 568, "HasRedReactor",     DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 572, "RedReactor???",     DataType::Float, false));
    values.InsertLast(VisOffsetValue(Vis, 580, "Turbo",             DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 592, "InputIsBraking",    DataType::Float));
    values.InsertLast(VisOffsetValue(Vis, 596, "BrakingCoefWeak",   DataType::Float, false));
    values.InsertLast(VisOffsetValue(Vis, 664, "SpoilerOpenNormed", DataType::Float));

    if (UI::BeginTable("##vis-offset-value-table", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Variable",     UI::TableColumnFlags::WidthFixed, 250.0f);
        UI::TableSetupColumn("Type",         UI::TableColumnFlags::WidthFixed, 90.0f);
        UI::TableSetupColumn("Value");
        UI::TableHeadersRow();

        UI::ListClipper clipper(values.Length);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                UI::TableNextRow();
                UI::TableNextColumn(); UI::Text(values[i][0]);
                UI::TableNextColumn(); UI::Text(values[i][1]);
                UI::TableNextColumn(); UI::Text(values[i][2]);
                UI::TableNextColumn(); UI::Text(values[i][3]);
                UI::TableNextColumn(); UI::Text(values[i][4]);
            }
        }

        UI::PopStyleColor();
        UI::EndTable();
    }
}

string[] VisOffsetValue(CSceneVehicleVis@ Vis, int offset, const string &in name, DataType type, bool known = true) {
    string value;

    switch (type) {
        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8  (Vis, offset) == 1); break;
        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8  (Vis, offset));      break;
        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8 (Vis, offset));      break;
        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16 (Vis, offset));      break;
        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(Vis, offset));      break;
        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32 (Vis, offset));      break;
        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(Vis, offset));      break;
        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64 (Vis, offset));      break;
        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(Vis, offset));      break;
        case DataType::Float:  value = Round(    Dev::GetOffsetFloat (Vis, offset));      break;
        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2  (Vis, offset));      break;
        case DataType::Vec3:   value = Round(    Dev::GetOffsetVec3  (Vis, offset));      break;
        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4  (Vis, offset));      break;
        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4  (Vis, offset));      break;
        default:;
    }

    return { tostring(offset), IntToHex(offset), (known ? "" : YELLOW) + name, tostring(type), value };
}

void RenderVisOffsets(CSceneVehicleVis@ Vis) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("CSceneVehicleVisState starts at offset ___ (0x___)");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    UI::TextWrapped("Values marked white are 0, " + GREEN + " green\\$G are positive/true, and " + RED + "red\\$G are negative/false.");

    if (UI::BeginTable("##vis-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(0.0f, 0.0f, 0.0f, 0.5f));

        UI::TableSetupScrollFreeze(0, 1);
        UI::TableSetupColumn("Offset (dec)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Offset (hex)", UI::TableColumnFlags::WidthFixed, 120.0f);
        UI::TableSetupColumn("Value (" + tostring(S_OffsetType) + ")");
        UI::TableHeadersRow();

        UI::ListClipper clipper((S_OffsetMax / S_OffsetSkip) + 1);
        while (clipper.Step()) {
            for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++) {
                int offset = i * S_OffsetSkip;
                string color = knownVisOffsets.Find(offset) > -1 ? "" : (observedVisOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                UI::TableNextColumn();
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   UI::Text(Round(    Dev::GetOffsetInt8  (Vis, offset) == 1)); break;
                        case DataType::Int8:   UI::Text(Round(    Dev::GetOffsetInt8  (Vis, offset)));      break;
                        case DataType::Uint8:  UI::Text(RoundUint(Dev::GetOffsetUint8 (Vis, offset)));      break;
                        case DataType::Int16:  UI::Text(Round(    Dev::GetOffsetInt16 (Vis, offset)));      break;
                        case DataType::Uint16: UI::Text(RoundUint(Dev::GetOffsetUint16(Vis, offset)));      break;
                        case DataType::Int32:  UI::Text(Round(    Dev::GetOffsetInt32 (Vis, offset)));      break;
                        case DataType::Uint32: UI::Text(RoundUint(Dev::GetOffsetUint32(Vis, offset)));      break;
                        case DataType::Int64:  UI::Text(Round(    Dev::GetOffsetInt64 (Vis, offset)));      break;
                        case DataType::Uint64: UI::Text(RoundUint(Dev::GetOffsetUint64(Vis, offset)));      break;
                        case DataType::Float:  UI::Text(Round(    Dev::GetOffsetFloat (Vis, offset)));      break;
                        case DataType::Vec2:   UI::Text(Round(    Dev::GetOffsetVec2  (Vis, offset)));      break;
                        case DataType::Vec3:   UI::Text(Round(    Dev::GetOffsetVec3  (Vis, offset)));      break;
                        case DataType::Vec4:   UI::Text(Round(    Dev::GetOffsetVec4  (Vis, offset)));      break;
                        case DataType::Iso4:   UI::Text(Round(    Dev::GetOffsetIso4  (Vis, offset)));      break;
                        default:;
                    }
                } catch {
                    UI::Text(YELLOW + getExceptionInfo());
                }
            }
        }
    }

    UI::PopStyleColor();
    UI::EndTable();
}

#endif