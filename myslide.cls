\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myslide}[2019/12/29 made by chenboshuo]

\def\myclasstype{article}% make sure a default is defined
\def\myclassoptions{a4paper,12pt} % 一般不加载

% 标志
\newif\if@Ebook
\newif\if@Beamer
\newif\if@Plain


% reference https://tex.stackexchange.com/questions/173643/how-can-i-set-up-my-custom-class-to-load-a-different-class-depending-on-the-clas
\RequirePackage{xkeyval}% better option processing - there are many other possibilities as you probably know so just adapt as needed

% 移动设备模式
\DeclareOptionX{ebook}{
  \gdef\myclasstype{article}
  \gdef\myclassoptions{12pt}
  \@Ebooktrue
}

% 幻灯片模式
\DeclareOptionX{slide}{
  \gdef\myclasstype{beamer}
  \gdef\myclassoptions{aspectratio=169}
  \@Beamertrue
}

% 打印模式
\DeclareOptionX{plain}{
  \gdef\myclasstype{article}
  \gdef\myclassoptions{a4paper,12pt}
  \@Plaintrue
  % \LoadClass[12pt]{article}
  % \RequirePackage[noxcolor]{beamerarticle}
  % \RequirePackage[papersize={108mm,144mm},margin=2mm]{geometry}
}
\DeclareOptionX*{%
  \PassOptionsToClass{\CurrentOption}{\myclasstype}%
}

\ProcessOptionsX
\LoadClass[\myclassoptions]{\myclasstype}

% 设置颜色
\RequirePackage{xcolor}


% 加载移动版选项
\if@Ebook
  \colorlet{fg}{black}
  \colorlet{bg}{white}
  \RequirePackage[noxcolor]{beamerarticle}
  \RequirePackage[papersize={108mm,144mm},margin=2mm]{geometry}
\fi

% 加载幻灯片选项
\if@Beamer
  \usetheme{metropolis}           % Use metropolis theme

  \metroset{sectionpage=progressbar,% 在每节标题下加进度条
            numbering=counter,% 展示页码
            block=fill%
            }
  % 调整logo位置
  \RequirePackage{eso-pic}
  \beamertemplatenavigationsymbolsempty
  \newcommand\AtPagemyUpperLeft[1]{\AtPageLowerLeft{%
  \put(\LenToUnit{0.825\paperwidth},\LenToUnit{0.9\paperheight}){#1}}}

  \renewcommand{\logo}[1]{
    \AddToShipoutPictureFG{
      \AtPagemyUpperLeft{#1}
    }%
  }
  \hypersetup{pdfpagemode=FullScreen} % 设置自动播放
\fi

% 加载打印版选项
\if@Plain
  \colorlet{fg}{black}
  \colorlet{bg}{white}
  \RequirePackage[noxcolor]{beamerarticle}
\fi

% 包
\RequirePackage{ctex} % 中文包

% 自动链接
% \RequirePackage[pdfusetitle]{hyperref}
\RequirePackage{hyperref}
\hypersetup{hidelinks} % 隐藏超链接周围红框

% 数学宏包
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{bm}

% booktabs 提供了\toprule 等命令.
\RequirePackage{booktabs}

% 插入图片
\RequirePackage{graphicx}
\RequirePackage{float}
% 物理单位
\RequirePackage{siunitx}
% 子图排版
\RequirePackage{subfigure}
% 积分符号
\RequirePackage{esint}  % various fancy integral symbols
% tikz
\RequirePackage{tikz}
\usetikzlibrary{math} % 一些数值计算
\usetikzlibrary{graphs} % 画节点图
\usetikzlibrary{matrix,backgrounds,positioning} % 画内存条需要的库

% 如果图片没有指定后缀, 依次按下列顺序搜索
\DeclareGraphicsExtensions{.pdf,.eps,.jpg,.png}

% 图片路径
\RequirePackage{graphicx}
\graphicspath{{./figures/}{../figures/}}

% 矢量
\renewcommand{\vec}[1]{\overrightarrow{#1}}
% \renewcommand{\vec}[1]{\boldsymbol{#1}}

% 微分命令
  %% 参考 https://liam.page/2017/05/01/the-correct-way-to-use-differential-operator/
\newcommand*{\dif}{\mathop{}\!\mathrm{d}}

% 除法命令
\newcommand*{\bdiv}{%
  \nonscript\mskip-\medmuskip\mkern5mu%
  \mathbin{\operator@font div}\penalty900\mkern5mu%
  \nonscript\mskip-\medmuskip
}

% 其他定理环境 引理, 推论已经定义
\newtheorem{conclusion}{结论}[section]
\newtheorem{defintion}{定义}

% 优化大于等于和小于等于
\renewcommand{\le}{\leqslant}
\renewcommand{\ge}{\geqslant}

% 算法环境
\RequirePackage{algorithm}
% \RequirePackage{clrscode}
\RequirePackage{clrscode3e}

% <- 的定义
\DeclareMathSymbol{\leftarrow}{\mathrel}{symbols}{"20}
\let\gets=\leftarrow

% 引用
\RequirePackage{cleveref}
\crefformat{equation}{#2公式(#1#3)}
\crefrangeformat{equation}{公式(#3#1#4)\;\~{}\;(#5#2#6)}
\crefmultiformat{equation}{公式(#2#1#3)}{ 和~(#2#1#3)}{，(#2#1#3)}{ 和~(#2#1#3)}


% reference https://tex.stackexchange.com/questions/20597/beamer-tikz-gradually-unveil-trees
\tikzset{
  hide on/.code={
    \only<presentation>{
      \only<#1>{\color{fg!0}}
    }
  },
  hide until/.code={
    \only<presentation>{
      \only< -#1>{\color{fg!0}}
      \only< #1> {\color{orange}}
    }
  },
  alert/.code={
    \only<presentation>{
      \only< #1> {\color{orange}}
    }
  },
  memoryrow/.style={% 内存条设置
      matrix of nodes,
      row 1/.style={nodes = {draw, minimum size=7mm}},
      column sep=-\pgflinewidth,
      row sep=-\pgflinewidth,
      nodes in empty cells,
      row 2/.style={nodes=rowlabel2},
      ampersand replacement=\&
    },
    arraynode/.style={
      draw,
      node contents={[\the\numexpr\pgfmatrixcurrentrow-2\relax][\the\numexpr\pgfmatrixcurrentcolumn-2\relax]},
      alias=n\the\numexpr\pgfmatrixcurrentrow-2\relax\the\numexpr\pgfmatrixcurrentcolumn-2\relax
      },
  columnlabel/.style={
      minimum size=0pt,
      draw=none,
      red,
      node contents={\the\numexpr\pgfmatrixcurrentcolumn-2\relax},
      alias=c\the\numexpr\pgfmatrixcurrentcolumn-2\relax
      },
  rowlabel/.style={
      minimum size=0pt,
      draw=none,
      red,
      node contents={\the\numexpr\pgfmatrixcurrentrow-2\relax},
      alias=r\the\numexpr\pgfmatrixcurrentrow-2\relax
      },
  emptynode/.style={node contents=~, draw=none},
  font=\ttfamily,
  array/.style={%
      matrix of nodes,
      nodes = arraynode,
      column sep=-\pgflinewidth,
      row sep=-\pgflinewidth,
      nodes in empty cells,
      row 1/.style={nodes=columnlabel},
      column 1/.style={nodes=rowlabel},
      row 1 column 1/.style={%
          nodes=emptynode}},
  rowlabel2/.style={
      inner sep=2pt,
      draw=none,
      font=\small\ttfamily,
      node contents={\the\numexpr-1+\pgfmatrixcurrentcolumn\relax},
      alias=m\the\numexpr-1+\pgfmatrixcurrentcolumn\relax
      },
  memory/.style={%
      matrix of nodes,
      nodes={draw, minimum size=6mm, anchor=center},
      row 1/.style={nodes = {columnlabel, black}},
      column 1/.style={nodes = {rowlabel, black}},
      row 1 column 1/.style={nodes = emptynode},
      column sep=-\pgflinewidth,
      row sep=-\pgflinewidth,
      nodes in empty cells,
  },
}


\newcommand{\alertshow}[2]{
  \onslide<#1->{%
    \mode<beamer>{%
      \alert<#1>{#2}
    }
    \mode<handout>{
      #2
    }
    \mode<article>{
      #2
    }
  }
}
% \newcommand{\onlyshow}[2]{
\newcommand{\onlyfocus}[2]{
  \only<beamer>{
    \only<#1>{\alert<#1>{#2}}
  }
}

% 关闭非slide的幻灯片标题
\mode<article>{
  \setbeamertemplate{frametitle}{}
}

% Reference in toc 参考文献
\RequirePackage[alldates=iso]{biblatex}
\newcommand{\upcite}[1]{$^{\mbox{\scriptsize \cite{#1}}}$}


% 设置代码环境
\RequirePackage{listings}
\RequirePackage{xcolor}

\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
\definecolor{codehighlight}{rgb}{0.95,0.8,0.8}
\definecolor{codebackground}{rgb}{0.95,0.95,0.95}

\lstdefinestyle{highlight}{
  firstnumber=auto,
  frame=tb,
  rulecolor=\color{gray!35},
  numbers=left,
  numberstyle=\tiny\color{gray},
  keywordstyle=\color{blue},
  commentstyle=\color{dkgreen},
  stringstyle=\color{mauve},
  backgroundcolor={},
  basicstyle={},
  tabsize=4,
  lineskip=0pt,
  aboveskip=0pt,
  belowskip=0pt,
  framesep=0pt,
  rulesep=0pt,
  framerule=0pt,
}


\lstdefinestyle{blue}{
  firstnumber=auto,
  frame=tb,
  % aboveskip=3mm,
  % aboveskip=0mm,
  % belowskip=3mm,
  % belowskip=0mm,
  % showstringspaces=false,
  % columns=flexible,
  % framerule=1pt,
  % % framerule=0pt,
  rulecolor=\color{gray!35},
  backgroundcolor=\color{gray!10},
  basicstyle={\small\ttfamily},
  numbers=left,
  numberstyle=\tiny\color{gray},
  keywordstyle=\color{blue},
  commentstyle=\color{dkgreen},
  stringstyle=\color{mauve},
  % breaklines=true,
  % breakatwhitespace=true,
  % tabsize=4,
}

\lstset{style=blue}

% \lstset{%
%   style=blue,
% }%

% https://github.com/cebe/linehighlight

% TIKZ libraries
\usetikzlibrary{shapes,shapes.multipart,backgrounds,calc,fit}

\newcommand{\highline}[1]{%
  \foreach \x in {#1}%
    \node[qahigh] at (0, 1 + -1 * \x) {%
    % Example for use of graphics for highlighting
    % uncomment and set graphics file for usage
    %        \begin{flushright}
    %        \includegraphics[height=\baselineskip]{graphics/left-arrow.pdf}
    %        \end{flushright}
    };%
}%


\newenvironment{linehighlight}[1]{
  \mode<beamer>{
    \lstset{style=highlight}%
  }
	% http://tex.stackexchange.com/a/17037/10327
	\def\lineHighlightLines{#1}
	\footnotesize
	\begin{tikzpicture}[%
	   % baseline=0pt,%
  		y=\baselineskip,%
  		% inner frame sep=0pt%
  	]%
		% Customize highlighting style here
		\tikzstyle{qahigh}=[fill=codehighlight,%
      text width=\textwidth+3.8pt,%
			minimum height=\baselineskip,%
      inner sep=0,
      outer xsep=-3.8pt,
      anchor=north west%
		];%
    %
		\node[rectangle, anchor=north west, outer sep=0, inner ysep=0] (codenode) at (0,0)%
		\bgroup% bgroup equals to {%
			\begin{minipage}{\textwidth}%
			\vspace{\baselineskip}
}{%
		  \end{minipage}%
		\egroup;% egroup equals to };%
    %
		\begin{pgfonlayer}{background}%
			\node[fill=codebackground,fit=(codenode), outer ysep=1] {};%
      % \lstset{style=highlight}%
      \mode<beamer>{
        \lineHighlightLines%
      }
		\end{pgfonlayer}%
	\end{tikzpicture}%
}
% \mode<article>{
%
% }
% \mode<handout>{
%   \newenvironment{linehighlight}[1]{}{}
% }

% reference https://tex.stackexchange.com/questions/107057/adjusting-font-size-with-tikz-picture
% 参数可以修改文字大小
% \tikzset{fontscale/.style = {font=\relsize{#1}}}
\usetikzlibrary{shapes.geometric, arrows}
\usetikzlibrary{calc}
\tikzstyle{flowchartNodeSettiings} = [%
  % minimum width=3cm,
  % minimum height=1cm,
  text centered,
  draw=black,
  % node distance=1.8cm,
  % text width=0.4\textwidth,
  % fontscale=1.2
]
\tikzstyle{startstop} = [%
  rectangle,
  rounded corners,
  flowchartNodeSettiings
]
\tikzstyle{io} = [%
  trapezium,
  trapezium left angle=70,
  trapezium right angle=110,
  flowchartNodeSettiings
]
\tikzstyle{process} = [
  rectangle,
  flowchartNodeSettiings
]
\tikzstyle{decision} = [
  diamond,
  aspect=2,
  % minimum width=5cm,
  % minimum height=1cm,
  text centered,
  draw=black,
  % node distance=3cm,
  % text width=0.3\textwidth,
  % fontscale=1.2
]
% reference https://tex.stackexchange.com/questions/611853/tikz-showing-all-node-names-for-debugging
\tikzstyle{debugstyle} = [
  append after command={% courtesy of Alenanno ref: https://tex.stackexchange.com/questions/287967/drawing-thin-line-around-a-multipart-tikz-shape#comment696552_287972
    \pgfextra{
      \tikzset{debugstyle/.style={}}
      \node [right,fill=white!20,text=gray!40]
        (\tikzlastnode name)
        at (\tikzlastnode.mid east)
        {\tikzlastnode};
      % \draw [->,gray!20] (\tikzlastnode name) -- (\tikzlastnode);
    }
  }
]
\tikzstyle{show node name} = [
  every node/.append style=debugstyle
]

% 符号表
\RequirePackage[symbols,nogroupskip,sort=none]{glossaries-extra}

% new keys must be defined before use
\glsaddstoragekey{unit}{}{\glossentryunit}
\glsnoexpandfields

\newglossarystyle{symbunitlong}{%
  \setglossarystyle{long3col}% base this style on the list style
  \renewenvironment{theglossary}{% Change the table type --> 3 columns
    \begin{longtable}{lp{\glsdescwidth}>{\centering\arraybackslash}p{2cm}}%
  }{
    \end{longtable}
  }%
  %
  \renewcommand*{\glossaryheader}{%  Change the table header
    \toprule[1.5pt]
    \bfseries 符号 & \bfseries 说明 & \bfseries 单位\\\hline
    \endhead
    \bottomrule[1.5pt]
    \vspace{2pt}
    \endfoot
  }%
  \renewcommand*{\glossentry}[2]{%  Change the displayed items
    \glstarget{##1}{\glossentryname{##1}} %
    & \glossentrydesc{##1}% Description
    & \glossentryunit{##1}  \tabularnewline
  }%
}

\def\symbolTableStatementWidth{0.9\textwidth}
% \newcommand{\setsymbolTableStatementWidth}[1][]{
%   \def\symbolTableStatementWidth{#1}
% }
\newglossarystyle{symblong}{%
  \setglossarystyle{long}% base this style on the list style
  \renewenvironment{theglossary}{% Change the table type --> 3 columns
    \begin{longtable}{lp{\symbolTableStatementWidth}}%
    % \begin{longtable}{cc}%

    % \begin{longtable}
  }{
    \end{longtable}
  }%
  %
  \renewcommand*{\glossaryheader}{%  Change the table header
    \toprule[1.5pt]
    \bfseries 符号 & \bfseries 说明 \\
    \hline
    \endhead
    \bottomrule[1.5pt]
    \vspace{2pt}
    \endfoot
  }%
  \renewcommand*{\glossentry}[2]{%  Change the displayed items
    \glstarget{##1}{\glossentryname{##1}} %
    & \glossentrydesc{##1}% Description
    \tabularnewline
  }%
}
\renewcommand{\glossarysection}[2][]{}

\endinput
