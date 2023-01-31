-module(scansfer_config).

-export([
    environment/0
]).

environment() ->
    read_secret("ENVIRONMENT", <<"DEV">>).
read_secret(SecretName, Default) ->
    RootPath = os:getenv("SECRETS_PATH", "./secrets/"),
    Path = filename:join([RootPath, SecretName, "secret"]),

    case file:read_file(Path) of
        {ok, Value} -> trim_trailing_newline(Value);
        {error, enoent} -> Default
    end.

trim_trailing_newline(B) ->
    case binary:last(B) of
        10 -> binary:part(B, {0, byte_size(B) - 1});
        _ -> B
    end.
