use mlua::prelude::*;

use glob::Pattern;

/// Check if a filename matches a glob pattern.
fn matches(_: &Lua, args: (String, String)) -> LuaResult<bool> {
    let (pattern, filename) = args;
    let p = Pattern::new(pattern.as_str()).expect("failed to parse pattern");
    Ok(p.matches(&filename))
}

#[mlua::lua_module]
fn glob(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("matches", lua.create_function(matches)?)?;
    Ok(exports)
}
