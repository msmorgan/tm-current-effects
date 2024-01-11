// c 2024-01-09
// m 2024-01-10

#if SIG_DEVELOPER && TMNEXT

bool   gameVersionValid = false;
string offsetSearch;
string version;

// offsets for which a value is known
const int[] knownStateOffsets = {
    80, 84, 88, 92, 96, 100, 396, 400, 404, 408
};

// offsets for which a value is known, but there's uncertainty in exactly what it represents
const int[] observedStateOffsets = {
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
            Tab_State();
        UI::EndTabBar();
    UI::End();
}

void Tab_State() {
    if (!UI::BeginTabItem("CSceneVehicleVisState"))
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

    UI::BeginTabBar("##state-tabs");
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
            CSceneVehicleVisState@ State = Vis.AsyncState;

            if (UI::BeginTabItem(i == 0 && meExists ? Icons::User + " Me" : i + "_" + Vis.Model.Id.GetName())) {
                UI::BeginTabBar("##state-tabs-single");

                if (UI::BeginTabItem("API Values")) {
                    try   { RenderStateApiValues(State); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("Offset Values")) {
                    try   { RenderStateOffsetValues(State); }
                    catch { UI::Text("error: " + getExceptionInfo()); }

                    UI::EndTabItem();
                }

                if (UI::BeginTabItem("Offsets")) {
                    try   { RenderStateOffsets(State); }
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

void RenderStateApiValues(CSceneVehicleVisState@ State) {
    UI::TextWrapped("Values are from CSceneVehicleVisState, which is inside CSceneVehicleVis.");

    string[][] values;
    values.InsertLast({"AirBrakeNormed",          "Float",   Round(    State.AirBrakeNormed)});
    values.InsertLast({"BulletTimeNormed",        "Float",   Round(    State.BulletTimeNormed)});
    values.InsertLast({"EngineOn",                "Bool",    Round(    State.EngineOn)});
    values.InsertLast({"CamGrpStates",            "Unknown", "unknown new type"});
    values.InsertLast({"CurGear",                 "Uint",    RoundUint(State.CurGear)});
    values.InsertLast({"Dir",                     "Vec3",    Round(    State.Dir)});
    values.InsertLast({"DiscontinuityCount",      "Uint8",   RoundUint(State.DiscontinuityCount)});
    values.InsertLast({"FLBreakNormedCoef",       "Float",   Round(    State.FLBreakNormedCoef)});
    values.InsertLast({"FLDamperLen",             "Float",   Round(    State.FLDamperLen)});
    values.InsertLast({"FLGroundContactMaterial", "Enum",    tostring( State.FLGroundContactMaterial)});
    values.InsertLast({"FLIcing01",               "Float",   Round(    State.FLIcing01)});
    values.InsertLast({"FLSlipCoef",              "Float",   Round(    State.FLSlipCoef)});
    values.InsertLast({"FLSteerAngle",            "Float",   Round(    State.FLSteerAngle)});
    values.InsertLast({"FLTireWear01",            "Float",   Round(    State.FLTireWear01)});
    values.InsertLast({"FLWheelRot",              "Float",   Round(    State.FLWheelRot)});
    values.InsertLast({"FLWheelRotSpeed",         "Float",   Round(    State.FLWheelRotSpeed)});
    values.InsertLast({"FRBreakNormedCoef",       "Float",   Round(    State.FRBreakNormedCoef)});
    values.InsertLast({"FRDamperLen",             "Float",   Round(    State.FRDamperLen)});
    values.InsertLast({"FRGroundContactMaterial", "Enum",    tostring( State.FRGroundContactMaterial)});
    values.InsertLast({"FRIcing01",               "Float",   Round(    State.FRIcing01)});
    values.InsertLast({"FRSlipCoef",              "Float",   Round(    State.FRSlipCoef)});
    values.InsertLast({"FRSteerAngle",            "Float",   Round(    State.FRSteerAngle)});
    values.InsertLast({"FrontSpeed",              "Float",   Round(    State.FrontSpeed)});
    values.InsertLast({"FRTireWear01",            "Float",   Round(    State.FRTireWear01)});
    values.InsertLast({"FRWheelRot",              "Float",   Round(    State.FRWheelRot)});
    values.InsertLast({"FRWheelRotSpeed",         "Float",   Round(    State.FRWheelRotSpeed)});
    values.InsertLast({"GroundDist",              "Float",   Round(    State.GroundDist)});
    values.InsertLast({"InputBrakePedal",         "Float",   Round(    State.InputBrakePedal)});
    values.InsertLast({"InputGasPedal",           "Float",   Round(    State.InputGasPedal)});
    values.InsertLast({"InputIsBraking",          "Bool",    Round(    State.InputIsBraking)});
    values.InsertLast({"InputSteer",              "Float",   Round(    State.InputSteer)});
    values.InsertLast({"InputVertical",           "Float",   Round(    State.InputVertical)});
    values.InsertLast({"IsGroundContact",         "Bool",    Round(    State.IsGroundContact)});
    values.InsertLast({"IsReactorGroundMode",     "Bool",    Round(    State.IsReactorGroundMode)});
    values.InsertLast({"IsTopContact",            "Bool",    Round(    State.IsTopContact)});
    values.InsertLast({"IsTurbo",                 "Bool",    Round(    State.IsTurbo)});
    values.InsertLast({"IsWheelsBurning",         "Bool",    Round(    State.IsWheelsBurning)});
    values.InsertLast({"Left",                    "Vec3",    Round(    State.Left)});
    values.InsertLast({"Position",                "Vec3",    Round(    State.Position)});
    values.InsertLast({"RaceStartTime",           "Uint",    RoundUint(State.RaceStartTime)});
    values.InsertLast({"ReactorAirControl",       "Vec3",    Round(    State.ReactorAirControl)});
    values.InsertLast({"ReactorBoostLvl",         "Enum",    tostring( State.ReactorBoostLvl)});
    values.InsertLast({"ReactorBoostType",        "Enum",    tostring( State.ReactorBoostType)});
    values.InsertLast({"ReactorInputsX",          "Bool",    Round(    State.ReactorInputsX)});
    values.InsertLast({"RLBreakNormedCoef",       "Float",   Round(    State.RLBreakNormedCoef)});
    values.InsertLast({"RLDamperLen",             "Float",   Round(    State.RLDamperLen)});
    values.InsertLast({"RLGroundContactMaterial", "Enum",    tostring( State.RLGroundContactMaterial)});
    values.InsertLast({"RLIcing01",               "Float",   Round(    State.RLIcing01)});
    values.InsertLast({"RLSlipCoef",              "Float",   Round(    State.RLSlipCoef)});
    values.InsertLast({"RLSteerAngle",            "Float",   Round(    State.RLSteerAngle)});
    values.InsertLast({"RLTireWear01",            "Float",   Round(    State.RLTireWear01)});
    values.InsertLast({"RLWheelRot",              "Float",   Round(    State.RLWheelRot)});
    values.InsertLast({"RLWheelRotSpeed",         "Float",   Round(    State.RLWheelRotSpeed)});
    values.InsertLast({"RRBreakNormedCoef",       "Float",   Round(    State.RRBreakNormedCoef)});
    values.InsertLast({"RRDamperLen",             "Float",   Round(    State.RRDamperLen)});
    values.InsertLast({"RRGroundContactMaterial", "Enum",    tostring( State.RRGroundContactMaterial)});
    values.InsertLast({"RRIcing01",               "Float",   Round(    State.RRIcing01)});
    values.InsertLast({"RRSlipCoef",              "Float",   Round(    State.RRSlipCoef)});
    values.InsertLast({"RRSteerAngle",            "Float",   Round(    State.RRSteerAngle)});
    values.InsertLast({"RRTireWear01",            "Float",   Round(    State.RRTireWear01)});
    values.InsertLast({"RRWheelRot",              "Float",   Round(    State.RRWheelRot)});
    values.InsertLast({"RRWheelRotSpeed",         "Float",   Round(    State.RRWheelRotSpeed)});
    values.InsertLast({"SimulationTimeCoef",      "Float",   Round(    State.SimulationTimeCoef)});
    values.InsertLast({"SpoilerOpenNormed",       "Float",   Round(    State.SpoilerOpenNormed)});
    values.InsertLast({"TurboTime",               "Float",   Round(    State.TurboTime)});
    values.InsertLast({"Up",                      "Vec3",    Round(    State.Up)});
    values.InsertLast({"WaterImmersionCoef",      "Float",   Round(    State.WaterImmersionCoef)});
    values.InsertLast({"WaterOverDistNormed",     "Float",   Round(    State.WaterOverDistNormed)});
    values.InsertLast({"WaterOverSurfacePos",     "Vec3",    Round(    State.WaterOverSurfacePos)});
    values.InsertLast({"WetnessValue01",          "Float",   Round(    State.WetnessValue01)});
    values.InsertLast({"WingsOpenNormed",         "Float",   Round(    State.WingsOpenNormed)});
    values.InsertLast({"WorldCarUp",              "Vec3",    Round(    State.WorldCarUp)});
    values.InsertLast({"WorldVel",                "Vec3",    Round(    State.WorldVel)});

    if (UI::BeginTable("##state-api-value-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
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

void RenderStateOffsetValues(CSceneVehicleVisState@ State) {
    UI::TextWrapped("Variables marked " + YELLOW + "yellow\\$G have been observed but are uncertain.");

    string[][] values;
    values.InsertLast(StateOffsetValue(State, 80,  "Position",  DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 92,  "WorldVel",  DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 396, "Up",        DataType::Vec3));
    values.InsertLast(StateOffsetValue(State, 408, "EngineRPM", DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 376, "IsWheelsBurning",   DataType::Bool));
    // values.InsertLast(StateOffsetValue(State, 384, "FLIcing01",         DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 388, "FRIcing01",         DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 392, "RRIcing01",         DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 396, "RLIcing01",         DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 400, "FLSlipCoef",        DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 404, "FRSlipCoef",        DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 408, "RRSlipCoef",        DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 412, "RLSlipCoef",        DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 416, "InputGasPedal",     DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 544, "InputIsBraking",    DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 548, "BrakingCoefStrong", DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 552, "HasReactor",        DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 556, "Reactor???",        DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 560, "HasYellowReactor",  DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 564, "YellowReactor???",  DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 568, "HasRedReactor",     DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 572, "RedReactor???",     DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 580, "Turbo",             DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 592, "InputIsBraking",    DataType::Float));
    // values.InsertLast(StateOffsetValue(State, 596, "BrakingCoefWeak",   DataType::Float, false));
    // values.InsertLast(StateOffsetValue(State, 664, "SpoilerOpenNormed", DataType::Float));

    if (UI::BeginTable("##state-offset-value-table", 5, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
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

string[] StateOffsetValue(CSceneVehicleVisState@ State, int offset, const string &in name, DataType type, bool known = true) {
    string offsets;
    string value;

    switch (type) {
        case DataType::Bool:   value = Round(    Dev::GetOffsetInt8  (State, offset) == 1); break;
        case DataType::Int8:   value = Round(    Dev::GetOffsetInt8  (State, offset));      break;
        case DataType::Uint8:  value = RoundUint(Dev::GetOffsetUint8 (State, offset));      break;
        case DataType::Int16:  value = Round(    Dev::GetOffsetInt16 (State, offset));      break;
        case DataType::Uint16: value = RoundUint(Dev::GetOffsetUint16(State, offset));      break;
        case DataType::Int32:  value = Round(    Dev::GetOffsetInt32 (State, offset));      break;
        case DataType::Uint32: value = RoundUint(Dev::GetOffsetUint32(State, offset));      break;
        case DataType::Int64:  value = Round(    Dev::GetOffsetInt64 (State, offset));      break;
        case DataType::Uint64: value = RoundUint(Dev::GetOffsetUint64(State, offset));      break;
        case DataType::Float:  value = Round(    Dev::GetOffsetFloat (State, offset));      break;
        case DataType::Vec2:   value = Round(    Dev::GetOffsetVec2  (State, offset));      break;
        case DataType::Vec3:
            value = Round(Dev::GetOffsetVec3(State, offset));
            offsets = offset + "," + (offset + 4) + "," + (offset + 8);
            break;
        case DataType::Vec4:   value = Round(    Dev::GetOffsetVec4  (State, offset));      break;
        case DataType::Iso4:   value = Round(    Dev::GetOffsetIso4  (State, offset));      break;
        default:;
    }

    return { offsets.Length > 0 ? offsets : tostring(offset), IntToHex(offset), (known ? "" : YELLOW) + name, tostring(type), value };
}

void RenderStateOffsets(CSceneVehicleVisState@ State) {
    UI::TextWrapped("If you go much further than a few thousand, there is a small, but non-zero chance your game could crash.");
    UI::TextWrapped("Offsets marked white are known, " + YELLOW + "yellow\\$G are somewhat known, and " + RED + "red\\$G are unknown.");
    UI::TextWrapped("Values marked white are 0, " + GREEN + " green\\$G are positive/true, and " + RED + "red\\$G are negative/false.");

    if (UI::BeginTable("##state-offset-table", 3, UI::TableFlags::RowBg | UI::TableFlags::ScrollY)) {
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
                string color = knownStateOffsets.Find(offset) > -1 ? "" : (observedStateOffsets.Find(offset) > -1) ? YELLOW : RED;

                UI::TableNextRow();
                UI::TableNextColumn();
                UI::Text(color + offset);

                UI::TableNextColumn();
                UI::Text(color + IntToHex(offset));

                UI::TableNextColumn();
                try {
                    switch (S_OffsetType) {
                        case DataType::Bool:   UI::Text(Round(    Dev::GetOffsetInt8  (State, offset) == 1)); break;
                        case DataType::Int8:   UI::Text(Round(    Dev::GetOffsetInt8  (State, offset)));      break;
                        case DataType::Uint8:  UI::Text(RoundUint(Dev::GetOffsetUint8 (State, offset)));      break;
                        case DataType::Int16:  UI::Text(Round(    Dev::GetOffsetInt16 (State, offset)));      break;
                        case DataType::Uint16: UI::Text(RoundUint(Dev::GetOffsetUint16(State, offset)));      break;
                        case DataType::Int32:  UI::Text(Round(    Dev::GetOffsetInt32 (State, offset)));      break;
                        case DataType::Uint32: UI::Text(RoundUint(Dev::GetOffsetUint32(State, offset)));      break;
                        case DataType::Int64:  UI::Text(Round(    Dev::GetOffsetInt64 (State, offset)));      break;
                        case DataType::Uint64: UI::Text(RoundUint(Dev::GetOffsetUint64(State, offset)));      break;
                        case DataType::Float:  UI::Text(Round(    Dev::GetOffsetFloat (State, offset)));      break;
                        case DataType::Vec2:   UI::Text(Round(    Dev::GetOffsetVec2  (State, offset)));      break;
                        case DataType::Vec3:   UI::Text(Round(    Dev::GetOffsetVec3  (State, offset)));      break;
                        case DataType::Vec4:   UI::Text(Round(    Dev::GetOffsetVec4  (State, offset)));      break;
                        case DataType::Iso4:   UI::Text(Round(    Dev::GetOffsetIso4  (State, offset)));      break;
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