--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local utils = require("utils.utils")

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local M = {}

local ts_utils = nil
local ts_locals = nil

local SIGN_NAME = "ContextSign"
local SIGN_GROUP = "context_signs"

-- See: https://github.com/lukas-reineke/indent-blankline.nvim/blob/64fdadb3ada61c4297452f7662789b01ee82ffcb/lua/ibl/scope_languages.lua
local CONTEXTABLE = {
  ada = {
    compilation = true,
    package_declaration = true,
    package_body = true,
    subprogram_declaration = true,
    subprogram_body = true,
    block_statement = true,
  },
  bash = {
    function_definition = true,
  },
  bass = {
    list = true,
    scope = true,
    cons = true,
  },
  bicep = {
    infrastructure = true,
    call_expression = true,

    lambda_expression = true,
    subscript_expression = true,

    if_statement = true,
    for_statement = true,

    array = true,
    object = true,
    interpolation = true,
  },
  bitbake = {
    python_function_definition = true,
    dictionary_comprehension = true,
    list_comprehension = true,
    set_comprehension = true,
  },
  c = {
    preproc_function_def = true,
    for_statement = true,
    if_statement = true,
    while_statement = true,
    function_definition = true,
    compound_statement = true,
    struct_specifier = true,
  },
  c_sharp = {
    block = true,
  },
  cairo = {
    block = true,
    function_definition = true,
    loop_expression = true,
    if_expression = true,
    match_expression = true,
    match_arm = true,

    struct_item = true,
    enum_item = true,
    impl_item = true,
  },
  capnp = {
    message = true,
    annotation_targets = true,
    const_list = true,
    enum = true,
    interface = true,
    implicit_generics = true,
    generics = true,
    group = true,
    method_parameters = true,
    named_return_types = true,
    struct = true,
    struct_shorthand = true,
    union = true,
  },
  commonlisp = {
    defun = true,
    sym_lit = true,
    loop_macro = true,
    list_lit = true,
  },
  corn = {
    object = true,
    array = true,
  },
  cpon = {
    meta_map = true,
    map = true,
    array = true,
  },
  cue = {
    field = true,
    for_clause = true,
  },
  dart = {
    body = true,
    block = true,
    if_statement = true,
    for_statement = true,
    while_statement = true,
    try_statement = true,
    catch_clause = true,
    finally_clause = true,
  },
  devicetree = {
    node = true,
    integer_cells = true,
  },
  ecma = {
    statement_block = true,
    ["function"] = true,
    arrow_function = true,
    function_declaration = true,
    method_definition = true,
    for_statement = true,
    for_in_statement = true,
    catch_clause = true,
  },
  elixir = {
    call = true,
    stab_clause = true,
  },
  elsa = {
    reduction = true,
  },
  fennel = {
    fn = true,
    lambda = true,
    let = true,
    each = true,
    ["for"] = true,
    match = true,
  },
  firrtl = {
    circuit = true,
    module = true,

    ["else"] = true,
    when = true,
  },
  fish = {
    command = true,
    function_definition = true,
    if_statement = true,
    for_statement = true,
    begin_statement = true,
    while_statement = true,
    switch_statement = true,
  },
  forth = {
    word_definition = true,
  },
  fusion = {
    block = true,
    eel_arrow_function = true,
    eel_object = true,
  },
  gdscript = {
    if_statement = true,
    elif_clause = true,
    else_clause = true,
    for_statement = true,
    while_statement = true,
    function_definition = true,
    constructor_definition = true,
    class_definition = true,
    match_statement = true,
    pattern_section = true,
    lambda = true,
    get_body = true,
    set_body = true,
  },
  gleam = {
    function_body = true,
    case_clause = true,
  },
  glimmer = {
    element_node = true,
    block_statement = true,
  },
  go = {
    func_literal = true,
    function_declaration = true,
    if_statement = true,
    block = true,
    expression_switch_statement = true,
    for_statement = true,
    method_declaration = true,
  },
  godot_resource = {
    section = true,
  },
  hare = {
    module = true,
    function_declaration = true,
    if_statement = true,
    for_statement = true,
    match_expression = true,
    switch_expression = true,
  },
  heex = {
    component = true,
    slot = true,
    tag = true,
  },
  html = {
    element = true,
  },
  java = {
    body = true,
    lambda_expression = true,
    enhanced_for_statement = true,
    block = true,
    if_statement = true,
    consequence = true,
    alternative = true,
    try_statement = true,
    catch_clause = true,
    for_statement = true,
    constructor_declaration = true,
    method_declaration = true,
  },
  json = {
    object = true,
    array = true,
  },
  jsonnet = {
    parenthesis = true,
    anonymous_function = true,
    object = true,
    field = true,
    local_bind = true,
  },
  julia = {
    function_definition = true,
    short_function_definition = true,
    macro_definition = true,
    for_statement = true,
    while_statement = true,
    try_statement = true,
    catch_clause = true,
    finally_clause = true,
    let_statement = true,
    quote_statement = true,
    do_clause = true,
  },
  kconfig = {
    config = true,
    menuconfig = true,
    choice = true,
    comment_entry = true,
    menu = true,
    ["if"] = true,
  },
  kdl = {
    node = true,
    node_children = true,
  },
  kotlin = {
    if_expression = true,
    when_expression = true,
    when_entry = true,

    for_statement = true,
    while_statement = true,
    do_while_statement = true,

    lambda_literal = true,
    function_declaration = true,
    primary_constructor = true,
    secondary_constructor = true,
    anonymous_initializer = true,

    class_declaration = true,
    enum_class_body = true,
    enum_entry = true,

    interpolated_expression = true,
  },
  lua = {
    -- chunk = true,
    do_statement = true,
    while_statement = true,
    repeat_statement = true,
    if_statement = true,
    for_statement = true,
    function_declaration = true,
    function_definition = true,
  },
  matlab = {
    function_definition = true,
  },
  mlir = {
    region = true,
  },
  nix = {
    let_expression = true,
    rec_attrset_expression = true,
    function_expression = true,
  },
  ocaml = {
    compilation_unit = true,
    structure = true,
    signature = true,
    module_binding = true,
    functor = true,
    let_binding = true,
    match_case = true,
    class_binding = true,
    class_function = true,
    method_definition = true,
    let_expression = true,
    fun_expression = true,
    for_expression = true,
    let_class_expression = true,
    object_expression = true,
    attribute_payload = true,
  },
  odin = {
    block = true,
    declaration = true,
    statement = true,
  },
  pascal = {
    root = true,

    defProc = true,
    lambda = true,
    declProc = true,
    declProcRef = true,

    exceptionHandler = true,
  },
  php = {
    class_declaration = true,
    method_declaration = true,
    function_definition = true,
    anonymous_function_creation_expression = true,
  },
  pony = {
    use_statement = true,
    actor_definition = true,
    class_definition = true,
    primitive_definition = true,
    interface_definition = true,
    trait_definition = true,
    struct_definition = true,

    constructor = true,
    method = true,
    behavior = true,

    if_statement = true,
    iftype_statement = true,
    elseif_block = true,
    elseiftype_block = true,
    else_block = true,
    for_statement = true,
    while_statement = true,
    try_statement = true,
    with_statement = true,
    repeat_statement = true,
    recover_statement = true,
    match_statement = true,
    case_statement = true,
    parenthesized_expression = true,
    tuple_expression = true,

    array_literal = true,
    object_literal = true,
  },
  puppet = {
    block = true,
    defined_resource_type = true,
    parameter_list = true,
    attribute_type_entry = true,
    class_definition = true,
    node_definition = true,
    resource_declaration = true,
    selector = true,
    method_call = true,
    case_statement = true,
    hash = true,
    array = true,
  },
  python = {
    module = true,
    class_definition = true,
    function_definition = true,
    dictionary_comprehension = true,
    list_comprehension = true,
    set_comprehension = true,
  },
  ql = {
    module = true,
    dataclass = true,
    datatype = true,
    select = true,
    body = true,
    conjunction = true,
  },
  query = {
    named_node = true,
    anonymous_node = true,
    grouping = true,
  },
  r = {
    function_definition = true,
  },
  rasi = {
    rule_set = true,
  },
  re2c = {
    body = true,
  },
  ron = {
    array = true,
    map = true,
    struct = true,
    tuple = true,
  },
  rst = {
    directive = true,
  },
  ruby = {
    method = true,
    class = true,
    block = true,
    do_block = true,
  },
  rust = {
    block = true,
    function_item = true,
    closure_expression = true,
    while_expression = true,
    for_expression = true,
    loop_expression = true,
    if_expression = true,
    match_expression = true,
    match_arm = true,
    expression_statement = true,

    struct_item = true,
    enum_item = true,
    impl_item = true,
  },
  scala = {
    template_body = true,
    lambda_expression = true,
    function_definition = true,
    block = true,
  },
  smali = {
    class_directive = true,
    expression = true,
    annotation_directive = true,
    array_data_directive = true,
    method_definition = true,
    packed_switch_directive = true,
    sparse_switch_directive = true,
    subannotation_directive = true,
  },
  sparql = {
    triples_block = true,
  },
  squirrel = {
    script = true,
    class_declaration = true,
    enum_declaration = true,
    function_declaration = true,
    attribute_declaration = true,

    array = true,
    block = true,
    table = true,
    anonymous_function = true,
    parenthesized_expression = true,

    if_statement = true,
    else_statement = true,
    while_statement = true,
    do_while_statement = true,
    switch_statement = true,
    for_statement = true,
    foreach_statement = true,
    try_statement = true,
    catch_statement = true,
  },
  starlark = {
    module = true,
    function_definition = true,
    dictionary_comprehension = true,
    list_comprehension = true,
    set_comprehension = true,
  },
  supercollider = {
    function_call = true,
    code_block = true,
    function_block = true,
    control_structure = true,
  },
  swift = {
    statements = true,
    for_statement = true,
    while_statement = true,
    repeat_while_statement = true,
    do_statement = true,
    if_statement = true,
    guard_statement = true,
    switch_statement = true,
    property_declaration = true,
    function_declaration = true,
    class_declaration = true,
    protocol_declaration = true,
  },
  systemtap = {
    function_definition = true,
    statement_block = true,
    if_statement = true,
    while_statement = true,
    for_statement = true,
    foreach_statement = true,
    catch_clause = true,
  },
  t32 = {
    block = true,
  },
  tablegen = {
    class = true,
    multiclass = true,
    def = true,
    defm = true,
    defset = true,
    defvar = true,
    foreach = true,
    ["if"] = true,
    let = true,
  },
  teal = {
    anon_function = true,
    function_statement = true,
    if_statement = true,
    for_body = true,
    repeat_statement = true,
    while_body = true,
    do_statement = true,
  },
  thrift = {
    definition = true,
  },
  tiger = {
    for_expression = true,
    let_expression = true,
    function_declaration = true,
  },
  tlaplus = {
    bounded_quantification = true,
    choose = true,
    function_definition = true,
    function_literal = true,
    lambda = true,
    let_in = true,
    module = true,
    module_definition = true,
    operator_definition = true,
    set_filter = true,
    set_map = true,
    unbounded_quantification = true,
    non_terminal_proof = true,
    suffices_proof_step = true,
    theorem = true,
    pcal_algorithm = true,
    pcal_macro = true,
    pcal_procedure = true,
    pcal_with = true,
  },
  toml = {
    table = true,
    table_array_element = true,
  },
  turlte = {
    turtle_doc = true,
  },
  ungrammar = {
    grammar = true,
  },
  usd = {
    block = true,
    metadata = true,
  },
  uxntal = {
    macro = true,
    memory_execution = true,
    subroutine = true,
  },
  v = {
    function_declaration = true,
    if_expression = true,
    block = true,
    for_statement = true,
  },
  verilog = {
    loop_generate_construct = true,
    loop_statement = true,
    conditional_statement = true,
    case_item = true,
    function_declaration = true,
    always_construct = true,
    module_declaration = true,
  },
  vim = {
    function_definition = true,
  },
  wing = {
    block = true,
  },
  yaml = {
    stream = true,
    block_node = true,
  },
  yuck = {
    ast_block = true,
    list = true,
    array = true,
    expr = true,
    json_array = true,
    json_object = true,
    parenthesized_expression = true,
  },
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
local function init_treesitter()
  if vim.treesitter == nil then
    return false
  end

  if ts_utils == nil then
    local ok, pkg = pcall(require, "nvim-treesitter.ts_utils")
    if not ok then
      return false
    end
    ts_utils = pkg
  end

  if ts_locals == nil then
    local ok, pkg = pcall(require, "nvim-treesitter.locals")
    if not ok then
      return false
    end
    ts_locals = pkg
  end

  return true
end

local function create_updater(bufnr)
  local function updater()
    if not init_treesitter() then
      return
    end

    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    vim.fn.sign_unplace(SIGN_GROUP, {
      buffer = bufnr,
    })

    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    local contextable_nodes = CONTEXTABLE[filetype]
    if contextable_nodes == nil then
      return
    end

    local cursor_node = ts_utils.get_node_at_cursor(0, true)
    if cursor_node == nil then
      return
    end
    local scope = ts_locals.get_scope_tree(cursor_node, bufnr)

    local nodes = {}
    for _, v in ipairs(scope) do
      table.insert(nodes, v:type())
    end

    local node = nil
    for _, v in ipairs(scope) do
      if contextable_nodes[v:type()] then
        node = v
        break
      end
    end

    if node == nil then
      return
    end

    local line_start, _, line_end, _ = node:range()
    for lnum = line_start + 1, line_end + 1 do
      vim.fn.sign_placelist({
        {
          id = lnum,
          group = SIGN_GROUP,
          name = SIGN_NAME,
          buffer = bufnr,
          lnum = lnum,
        },
      })
    end
  end
  return updater
end

--------------------------------------------------------------------------------
-- Modules
--------------------------------------------------------------------------------
---@class modules.contextsigns.Config
M.defaults = {}

---@param opts? modules.contextsigns.Config
M.setup = function(opts)
  -- Debounced debounced.
  ---@type { [number]: { [1]: (fun(): nil), [2]: (fun(): nil) } }
  local debounced_updates = {}

  -- Define signs.
  if #vim.fn.sign_getdefined(SIGN_NAME) > 0 then
    vim.fn.sign_undefine({ SIGN_NAME })
  end
  vim.fn.sign_define(SIGN_NAME, {
    text = "|",
    texthl = "ContextSign",
  })

  -- Add auto commands.
  local group = augroup("ContextSigns", { clear = true })

  autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    callback = function(e)
      local debounced = debounced_updates[e.buf]
      if debounced == nil then
        debounced = { utils.debounce(create_updater(e.buf), 50) }
        debounced_updates[e.buf] = debounced
      end

      local update = debounced[1]
      update()
    end,
  })

  autocmd("BufLeave", {
    group = group,
    callback = function(e)
      local debounced = debounced_updates[e.buf]
      if debounced ~= nil then
        local cancel = debounced[2]
        cancel()
        debounced_updates[e.buf] = nil
      end

      -- Remove signs.
      vim.fn.sign_unplace(SIGN_GROUP, {
        buffer = e.buf,
      })
    end,
  })
end

--------------------------------------------------------------------------------
-- Export
--------------------------------------------------------------------------------
return M
