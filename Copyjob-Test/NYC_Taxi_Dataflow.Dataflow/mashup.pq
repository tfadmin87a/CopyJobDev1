[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared green_tripdata_2022 = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "460e1ef8-33d4-4878-bd99-5062ed598e22"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "22c6057a-41fb-42b1-8d4f-71e7e5fa1b71"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "green_tripdata_2022", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"lpep_pickup_datetime", type date}}),
  #"Filtered rows" = Table.SelectRows(#"Changed column type", each ([store_and_fwd_flag] = "Y")),
  #"Filtered rows 1" = Table.SelectRows(#"Filtered rows", each [lpep_pickup_datetime] >= #date(2022, 1, 1) and [lpep_pickup_datetime] <= #date(2022, 1, 31)),
  #"Renamed columns" = Table.RenameColumns(#"Filtered rows 1", {{"lpep_pickup_datetime", "lpep_pickup_datetime"}, {"lpep_dropoff_datetime", "lpep_dropoff_datetime"}}),
  #"Filtered rows 2" = Table.SelectRows(#"Renamed columns", each [PULocationID] = PUlocationID)
in
  #"Filtered rows 2";
shared #"nyc-taxi-green-discounts" = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "460e1ef8-33d4-4878-bd99-5062ed598e22"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "22c6057a-41fb-42b1-8d4f-71e7e5fa1b71"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "nyc-taxi-green-discounts", ItemKind = "Table"]}[Data],
  #"Promoted headers" = Table.PromoteHeaders(#"Navigation 2", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"VendorID", Int64.Type}, {"2015-01-01", Int64.Type}, {"2015-01-02", Int64.Type}, {"2015-01-03", Int64.Type}, {"2015-01-04", Int64.Type}, {"2015-01-05", Int64.Type}, {"2015-01-06", Int64.Type}, {"2015-01-07", Int64.Type}, {"2015-01-08", Int64.Type}, {"2015-01-09", Int64.Type}, {"2015-01-10", Int64.Type}, {"2015-01-11", Int64.Type}, {"2015-01-12", Int64.Type}, {"2015-01-13", Int64.Type}, {"2015-01-14", Int64.Type}, {"2015-01-15", Int64.Type}, {"2015-01-16", Int64.Type}, {"2015-01-17", Int64.Type}, {"2015-01-18", Int64.Type}, {"2015-01-19", Int64.Type}, {"2015-01-20", Int64.Type}, {"2015-01-21", Int64.Type}, {"2015-01-22", Int64.Type}, {"2015-01-23", Int64.Type}, {"2015-01-24", Int64.Type}, {"2015-01-25", Int64.Type}, {"2015-01-26", Int64.Type}, {"2015-01-27", Int64.Type}, {"2015-01-28", Int64.Type}, {"2015-01-29", Int64.Type}, {"2015-01-30", Int64.Type}, {"2015-01-31", Int64.Type}}),
  #"Unpivoted other columns" = Table.UnpivotOtherColumns(#"Changed column type", {"VendorID"}, "Date", "Discount"),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Unpivoted other columns", {{"Date", type date}})
in
  #"Changed column type 1";
shared output = let
  Source = Table.NestedJoin(green_tripdata_2022, {"VendorID"}, #"nyc-taxi-green-discounts", {"VendorID"}, "nyc-taxi-green-discounts", JoinKind.Inner)
in
  Source;
shared PUlocationID = 244 meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type number];
