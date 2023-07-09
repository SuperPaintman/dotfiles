{ fetchFromGitHub, ... }:

{
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
}
