{ fetchFromGitHub, ... }:

{
  alpha-nvim = {
    pname = "alpha-nvim";
    version = "0.0.0+rev=9e33db3";
    src = fetchFromGitHub {
      owner = "goolord";
      repo = "alpha-nvim";
      rev = "9e33db324b8bb7a147bce9ea5496686ee859461d";
      sha256 = "sha256-DgKL4BgEVGSESxdBf8CbWMeAkcN/7vi1DuqIZVvmtlA=";
    };
    commit = "9e33db324b8bb7a147bce9ea5496686ee859461d";
    plugin = "goolord/alpha-nvim";
  };

  auto-session = {
    pname = "auto-session";
    version = "0.0.0+rev=7afbb14";
    src = fetchFromGitHub {
      owner = "rmagatti";
      repo = "auto-session";
      rev = "7afbb149f87be279778689596c781882014f7eef";
      sha256 = "sha256-bmNrQQnaA+c9DsSTChS87Ir9+xlhlue9yl4VmqXWaB8=";
    };
    commit = "7afbb149f87be279778689596c781882014f7eef";
    plugin = "rmagatti/auto-session";
  };

  bufferline-nvim = {
    pname = "bufferline-nvim";
    version = "0.0.0+rev=655133c";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "bufferline.nvim";
      rev = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3";
      sha256 = "sha256-ae4MB6+6v3awvfSUWlau9ASJ147ZpwuX1fvJdfMwo1Q=";
    };
    commit = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3";
    plugin = "akinsho/bufferline.nvim";
  };

  catppuccin = {
    pname = "catppuccin";
    version = "0.0.0+rev=8338b02";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "8338b02e9a8ffcb999520de7f15943712618760f";
      sha256 = "sha256-ALeldtRjaFcEbIfAMiPY85aUPFTk+M8LCdJeGz1kqns=";
    };
    commit = "8338b02e9a8ffcb999520de7f15943712618760f";
    plugin = "catppuccin/nvim";
  };

  cmp-buffer = {
    pname = "cmp-buffer";
    version = "0.0.0+rev=3022dbc";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-buffer";
      rev = "3022dbc9166796b644a841a02de8dd1cc1d311fa";
      sha256 = "sha256-dG4U7MtnXThoa/PD+qFtCt76MQ14V1wX8GMYcvxEnbM=";
    };
    commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa";
    plugin = "hrsh7th/cmp-buffer";
  };

  cmp-nvim-lsp = {
    pname = "cmp-nvim-lsp";
    version = "0.0.0+rev=44b16d1";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "44b16d11215dce86f253ce0c30949813c0a90765";
      sha256 = "sha256-mU0soCz79erJXMMqD/FyrJZ0mu2n6fE0deymPzQlxts=";
    };
    commit = "44b16d11215dce86f253ce0c30949813c0a90765";
    plugin = "hrsh7th/cmp-nvim-lsp";
  };

  cmp-nvim-lua = {
    pname = "cmp-nvim-lua";
    version = "0.0.0+rev=f12408b";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lua";
      rev = "f12408bdb54c39c23e67cab726264c10db33ada8";
      sha256 = "sha256-6eXOK1mVK06TN1akhN42Bo4wQpeen3rk3b/m7iVmGKM=";
    };
    commit = "f12408bdb54c39c23e67cab726264c10db33ada8";
    plugin = "hrsh7th/cmp-nvim-lua";
  };

  cmp-path = {
    pname = "cmp-path";
    version = "0.0.0+rev=91ff86c";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-path";
      rev = "91ff86cd9c29299a64f968ebb45846c485725f23";
      sha256 = "sha256-thppiiV3wjIaZnAXmsh7j3DUc6ceSCvGzviwFUnoPaI=";
    };
    commit = "91ff86cd9c29299a64f968ebb45846c485725f23";
    plugin = "hrsh7th/cmp-path";
  };

  cmp_luasnip = {
    pname = "cmp_luasnip";
    version = "0.0.0+rev=1809552";
    src = fetchFromGitHub {
      owner = "saadparwaiz1";
      repo = "cmp_luasnip";
      rev = "18095520391186d634a0045dacaa346291096566";
      sha256 = "sha256-Z5SPy3j2oHFxJ7bK8DP8Q/oRyLEMlnWyIfDaQcNVIS0=";
    };
    commit = "18095520391186d634a0045dacaa346291096566";
    plugin = "saadparwaiz1/cmp_luasnip";
  };

  comment-nvim = {
    pname = "comment-nvim";
    version = "0.0.0+rev=3d22da7";
    src = fetchFromGitHub {
      owner = "numToStr";
      repo = "Comment.nvim";
      rev = "3d22da7f8d72d3eafe1491a7f05ea775b930c481";
      sha256 = "sha256-VCngzRxHRUN3OiAYKWYcKyXGkG6mfkomWQxPave8/Ss=";
    };
    commit = "3d22da7f8d72d3eafe1491a7f05ea775b930c481";
    plugin = "numToStr/Comment.nvim";
  };

  copilot-cmp = {
    pname = "copilot-cmp";
    version = "0.0.0+rev=72fbaa0";
    src = fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot-cmp";
      rev = "72fbaa03695779f8349be3ac54fa8bd77eed3ee3";
      sha256 = "sha256-srgNohm/aJpswNJ5+T7p+zi9Jinp9e5FA8/wdk6VRiY=";
    };
    commit = "72fbaa03695779f8349be3ac54fa8bd77eed3ee3";
    plugin = "zbirenbaum/copilot-cmp";
  };

  copilot-lua = {
    pname = "copilot-lua";
    version = "0.0.0+rev=858bbfa";
    src = fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot.lua";
      rev = "858bbfa6fa81c88fb1f64107d7981f1658619e0a";
      sha256 = "sha256-x6ylgVR7nrMhvSvtwbh7CufOJO/q+30G+Tvrj3/wgZY=";
    };
    commit = "858bbfa6fa81c88fb1f64107d7981f1658619e0a";
    plugin = "zbirenbaum/copilot.lua";
  };

  diffview-nvim = {
    pname = "diffview-nvim";
    version = "0.0.0+rev=766a4f2";
    src = fetchFromGitHub {
      owner = "sindrets";
      repo = "diffview.nvim";
      rev = "766a4f210e67e522659302dc6bd8a8d3b8c08c54";
      sha256 = "sha256-UCESOnaVwRwKfK0WB0/woKc+3zr1vqBTMckSiUxD2Ls=";
    };
    commit = "766a4f210e67e522659302dc6bd8a8d3b8c08c54";
    plugin = "sindrets/diffview.nvim";
  };

  gitsigns-nvim = {
    pname = "gitsigns-nvim";
    version = "0.0.0+rev=dc2962f";
    src = fetchFromGitHub {
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      rev = "dc2962f7fce953a2a98e7c6d3d7fc4c1d1f66758";
      sha256 = "sha256-FomOBFwUrvE4QaQ49J86zIafvEde6cNsiNbJ3JzVK58=";
    };
    commit = "dc2962f7fce953a2a98e7c6d3d7fc4c1d1f66758";
    plugin = "lewis6991/gitsigns.nvim";
  };

  lsp-signature-nvim = {
    pname = "lsp-signature-nvim";
    version = "0.0.0+rev=33250c8";
    src = fetchFromGitHub {
      owner = "ray-x";
      repo = "lsp_signature.nvim";
      rev = "33250c84c7a552daf28ac607d9d9e82f88cd0907";
      sha256 = "sha256-UEgCImIGDFcyujwyN7GMs3NBcZiUNWQxygkMqZjJ7jE=";
    };
    commit = "33250c84c7a552daf28ac607d9d9e82f88cd0907";
    plugin = "ray-x/lsp_signature.nvim";
  };

  lspsaga-nvim = {
    pname = "lspsaga-nvim";
    version = "0.0.0+rev=7ebd0cc";
    src = fetchFromGitHub {
      owner = "nvimdev";
      repo = "lspsaga.nvim";
      rev = "7ebd0cc5923c81516c1c050fc9aea70bec23fd02";
      sha256 = "sha256-VF7zuxxHVs0uSDNGzswrBsKSmATC7byyEG+LZSEwTxM=";
    };
    commit = "7ebd0cc5923c81516c1c050fc9aea70bec23fd02";
    plugin = "nvimdev/lspsaga.nvim";
  };

  lualine-nvim = {
    pname = "lualine-nvim";
    version = "0.0.0+rev=e545924";
    src = fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "e5459241bde5949305b9583bb4eedf322a2a8e7c";
      sha256 = "sha256-dh/5ph4javntGGMAmwYFBo9dr8iD0JyA3W/lmFJr1fc=";
    };
    commit = "e5459241bde5949305b9583bb4eedf322a2a8e7c";
    plugin = "nvim-lualine/lualine.nvim";
  };

  luasnip = {
    pname = "luasnip";
    version = "0.0.0+rev=a658ae2";
    src = fetchFromGitHub {
      owner = "L3MON4D3";
      repo = "LuaSnip";
      rev = "a658ae2906344a1d2b9c507738e585cf68e685c7";
      sha256 = "sha256-tH1VINoPuzdDrNuvFkV3sOiRcUCVDChR7bYbrAao2bk=";
    };
    commit = "a658ae2906344a1d2b9c507738e585cf68e685c7";
    plugin = "L3MON4D3/LuaSnip";
  };

  neodev-nvim = {
    pname = "neodev-nvim";
    version = "0.0.0+rev=80487e4";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "neodev.nvim";
      rev = "80487e4f7bfa11c2ef2a1b461963db019aad6a73";
      sha256 = "sha256-cTK0InESf30wlDY/Qo7NkBXumG43rAoS/fE4jjRUK44=";
    };
    commit = "80487e4f7bfa11c2ef2a1b461963db019aad6a73";
    plugin = "folke/neodev.nvim";
  };

  neogit = {
    pname = "neogit";
    version = "0.0.0+rev=d8bf910";
    src = fetchFromGitHub {
      owner = "NeogitOrg";
      repo = "neogit";
      rev = "d8bf9102692250193b855acd9025a826f1af2729";
      sha256 = "sha256-BBre2HyecQp1TlhJEWbkUpeu5Y4urZVgVf4dqU7RQT0=";
    };
    commit = "d8bf9102692250193b855acd9025a826f1af2729";
    plugin = "NeogitOrg/neogit";
  };

  none-ls-nvim = {
    pname = "none-ls-nvim";
    version = "0.0.0+rev=e2cbdcb";
    src = fetchFromGitHub {
      owner = "nvimtools";
      repo = "none-ls.nvim";
      rev = "e2cbdcb986e35461db9c6d9ba98f45bd272ac913";
      sha256 = "sha256-5He67+EJ6da+jKLtuksozL8fc/SWigkzGdcY5nr6QFg=";
    };
    commit = "e2cbdcb986e35461db9c6d9ba98f45bd272ac913";
    plugin = "nvimtools/none-ls.nvim";
  };

  nvim-cmp = {
    pname = "nvim-cmp";
    version = "0.0.0+rev=2743dd9";
    src = fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "2743dd989e9b932e1b4813a4927d7b84272a14e2";
      sha256 = "sha256-nK+RmsrAFxo0ZrpaIdFe/24kwfE7wjYMqf9u917yYo4=";
    };
    commit = "2743dd989e9b932e1b4813a4927d7b84272a14e2";
    plugin = "hrsh7th/nvim-cmp";
  };

  nvim-dap = {
    pname = "nvim-dap";
    version = "0.0.0+rev=04ce47f";
    src = fetchFromGitHub {
      owner = "mfussenegger";
      repo = "nvim-dap";
      rev = "04ce47fc5a6ef2b717f33c320fc003091cebac40";
      sha256 = "sha256-evpP8qAtNuEL1EVUVoCB+PQ1Mmn08FJuufkwnOT+oTg=";
    };
    commit = "04ce47fc5a6ef2b717f33c320fc003091cebac40";
    plugin = "mfussenegger/nvim-dap";
  };

  nvim-dap-ui = {
    pname = "nvim-dap-ui";
    version = "0.0.0+rev=f7d75cc";
    src = fetchFromGitHub {
      owner = "rcarriga";
      repo = "nvim-dap-ui";
      rev = "f7d75cca202b52a60c520ec7b1ec3414d6e77b0f";
      sha256 = "sha256-cMpJJ2npriAFajLw1SEyDMjKUBFVFvYBr4dmFKoZyKw=";
    };
    commit = "f7d75cca202b52a60c520ec7b1ec3414d6e77b0f";
    plugin = "rcarriga/nvim-dap-ui";
  };

  nvim-dap-virtual-text = {
    pname = "nvim-dap-virtual-text";
    version = "0.0.0+rev=df66808";
    src = fetchFromGitHub {
      owner = "theHamsta";
      repo = "nvim-dap-virtual-text";
      rev = "df66808cd78b5a97576bbaeee95ed5ca385a9750";
      sha256 = "sha256-WvxJrOIE7gwZ9c1Ok8ysEDUjBS/34vMM4EmWcRqps0I=";
    };
    commit = "df66808cd78b5a97576bbaeee95ed5ca385a9750";
    plugin = "theHamsta/nvim-dap-virtual-text";
  };

  nvim-lspconfig = {
    pname = "nvim-lspconfig";
    version = "0.0.0+rev=0011c43";
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "0011c435282f043a018e23393cae06ed926c3f4a";
      sha256 = "sha256-17n6Vxp+HOUpdmWB6EI4QyTowVi0tILJRFISJP96YYk=";
    };
    commit = "0011c435282f043a018e23393cae06ed926c3f4a";
    plugin = "neovim/nvim-lspconfig";
  };

  nvim-nio = {
    pname = "nvim-nio";
    version = "0.0.0+rev=a428f30";
    src = fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "nvim-nio";
      rev = "a428f309119086dc78dd4b19306d2d67be884eee";
      sha256 = "sha256-i6imNTb1xrfBlaeOyxyIwAZ/+o6ew9C4/z34a7/BgFg=";
    };
    commit = "a428f309119086dc78dd4b19306d2d67be884eee";
    plugin = "nvim-neotest/nvim-nio";
  };

  nvim-tree-lua = {
    pname = "nvim-tree-lua";
    version = "0.0.0+rev=4af5722";
    src = fetchFromGitHub {
      owner = "nvim-tree";
      repo = "nvim-tree.lua";
      rev = "4af572246ce49883e2a52c49203a19984454f2e0";
      sha256 = "sha256-c4xsbCGsm67wssPdmRoHk/8HEOqlPu1RHSWKlvEI9vw=";
    };
    commit = "4af572246ce49883e2a52c49203a19984454f2e0";
    plugin = "nvim-tree/nvim-tree.lua";
  };

  nvim-treesitter-playground = {
    pname = "nvim-treesitter-playground";
    version = "0.0.0+rev=2b81a01";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "playground";
      rev = "2b81a018a49f8e476341dfcb228b7b808baba68b";
      sha256 = "sha256-2wSTVSkuEvTAq3tB5yLw13WWpp1lAycCL4U1BKMm8Kw=";
    };
    commit = "2b81a018a49f8e476341dfcb228b7b808baba68b";
    plugin = "nvim-treesitter/playground";
  };

  nvim-treesitter-textobjects = {
    pname = "nvim-treesitter-textobjects";
    version = "0.0.0+rev=5ca4aaa";
    src = fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter-textobjects";
      rev = "5ca4aaa6efdcc59be46b95a3e876300cfead05ef";
      sha256 = "sha256-lf+AwSu96iKO1vWWU2D7jWHGfjXkbX9R2CX3gMZaD4M=";
    };
    commit = "5ca4aaa6efdcc59be46b95a3e876300cfead05ef";
    plugin = "nvim-treesitter/nvim-treesitter-textobjects";
  };

  nvim-web-devicons = {
    pname = "nvim-web-devicons";
    version = "0.0.0+rev=9ab9b0b";
    src = fetchFromGitHub {
      owner = "nvim-tree";
      repo = "nvim-web-devicons";
      rev = "9ab9b0b894b2388a9dbcdee5f00ce72e25d85bf9";
      sha256 = "sha256-lN8LUgQ0sJDMByFkUmfVy6h2EVPAP3hqrwqE0++XgMQ=";
    };
    commit = "9ab9b0b894b2388a9dbcdee5f00ce72e25d85bf9";
    plugin = "nvim-tree/nvim-web-devicons";
  };

  omnisharp-extended-lsp-nvim = {
    pname = "omnisharp-extended-lsp-nvim";
    version = "0.0.0+rev=53edfb4";
    src = fetchFromGitHub {
      owner = "Hoffs";
      repo = "omnisharp-extended-lsp.nvim";
      rev = "53edfb413a54c9e55dcddc9e9fa4977a897e4425";
      sha256 = "sha256-rVjsYeBlqY5vKOdhjxDmpm2kKYV6h9vjt8ToG+PEm7s=";
    };
    commit = "53edfb413a54c9e55dcddc9e9fa4977a897e4425";
    plugin = "Hoffs/omnisharp-extended-lsp.nvim";
  };

  plenary-nvim = {
    pname = "plenary-nvim";
    version = "0.0.0+rev=253d348";
    src = fetchFromGitHub {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "253d34830709d690f013daf2853a9d21ad7accab";
      sha256 = "sha256-z5JHuQcF1EvySnRBywl6EOrp8aRO0nd2dnkXJg2ge58=";
    };
    commit = "253d34830709d690f013daf2853a9d21ad7accab";
    plugin = "nvim-lua/plenary.nvim";
  };

  telescope-nvim = {
    pname = "telescope-nvim";
    version = "0.0.0+rev=776b509";
    src = fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "776b509f80dd49d8205b9b0d94485568236d1192";
      sha256 = "sha256-fV3LLRwAPykVGc4ImOnUSP+WTrPp9Ad9OTfBJ6wqTMk=";
    };
    commit = "776b509f80dd49d8205b9b0d94485568236d1192";
    plugin = "nvim-telescope/telescope.nvim";
  };

  trouble-nvim = {
    pname = "trouble-nvim";
    version = "0.0.0+rev=e7805dc";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "trouble.nvim";
      rev = "e7805dc3448f28599e022dc7a0e58060dfdeeb9a";
      sha256 = "sha256-16036o4yQQH4/acPucdQfys+ozLrVAnhFrN1xPIFdUI=";
    };
    commit = "e7805dc3448f28599e022dc7a0e58060dfdeeb9a";
    plugin = "folke/trouble.nvim";
  };

  which-key-nvim = {
    pname = "which-key-nvim";
    version = "0.0.0+rev=65b36cc";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "which-key.nvim";
      rev = "65b36cc258e857dea92fc11cdc0d6e2bb01d3e87";
      sha256 = "sha256-SGOc94MYh5W1rX3kif86DVX5G1KuGZfY3uvb8DGNG7I=";
    };
    commit = "65b36cc258e857dea92fc11cdc0d6e2bb01d3e87";
    plugin = "folke/which-key.nvim";
  };
}
