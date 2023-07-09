{ fetchFromGitHub, ... }:

{
  bufferline-nvim = {
    pname = "bufferline-nvim";
    version = "0.0.0+rev=2f391fd";
    src = fetchFromGitHub {
      owner = "akinsho";
      repo = "bufferline.nvim";
      rev = "2f391fde91b9c3876eee359ee24cc352050e5e48";
      sha256 = "sha256-e+TaXvZI+nfnK3gFoLK5ffwsm6B+15YCeehnoISK4mE=";
    };
    commit = "2f391fde91b9c3876eee359ee24cc352050e5e48";
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

  lualine-nvim = {
    pname = "lualine-nvim";
    version = "0.0.0+rev=442d2ab";
    src = fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "442d2ab757b4de6bc492186ff76ffed9746d772b";
      sha256 = "sha256-Ho0TM+pHEz5KYs0KIFTDLbLKY/O9/Fx0YWuZZVpUwEw=";
    };
    commit = "442d2ab757b4de6bc492186ff76ffed9746d772b";
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

  null-ls-nvim = {
    pname = "null-ls-nvim";
    version = "0.0.0+rev=e45670a";
    src = fetchFromGitHub {
      owner = "jose-elias-alvarez";
      repo = "null-ls.nvim";
      rev = "e45670abdcda293282b7a00d0e2f7d473e7d6251";
      sha256 = "sha256-s7jPzm9Skt/eubfvtfzRazSJsdeyZgPnJSSzNLsUbSM=";
    };
    commit = "e45670abdcda293282b7a00d0e2f7d473e7d6251";
    plugin = "jose-elias-alvarez/null-ls.nvim";
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
