def fromrfc3339:
  (capture("(?<datetime>[^.]*)(\\.(?<frac>\\d+))?(?<tz>Z|([-+].*))$")) as $parts |
  (
    $parts.datetime + ($parts.tz | gsub(":"; ""))
  ) as $parsable_string |
  (
    ($parsable_string | strptime("%Y-%m-%dT%H:%M:%S%z") | mktime) +
    ("0." + $parts.frac | tonumber)
  );
