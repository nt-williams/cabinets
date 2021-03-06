% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cabinets.R
\name{FileCabinet}
\alias{FileCabinet}
\title{R6 class for a cabinet}
\description{
Constructs an R6 class of FileCabinet. Objects of class
FileCabinet contain information that is used by \code{new_cabinet_proj()}
to create project directories.
}
\examples{

## ------------------------------------------------
## Method `FileCabinet$new`
## ------------------------------------------------

FileCabinet$new("test", "a/path",
                list(code = NULL, 'data/derived' = NULL, 'data/source' = NULL))
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{name}}{cabinet name.}

\item{\code{directory}}{the path to where future directories will be created, a string.}

\item{\code{structure}}{the directory structure, a list.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{FileCabinet$new()}}
\item \href{#method-print}{\code{FileCabinet$print()}}
\item \href{#method-clone}{\code{FileCabinet$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FileCabinet$new(name, directory, structure)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{name}}{cabinet name.}

\item{\code{directory}}{the path to where future directories will be created, a string.}

\item{\code{structure}}{the directory structure, a list.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
Create a new `FileCabinet` object.
}

\subsection{Returns}{
A cabinet object.
}
\subsection{Examples}{
\if{html}{\out{<div class="r example copy">}}
\preformatted{FileCabinet$new("test", "a/path",
                list(code = NULL, 'data/derived' = NULL, 'data/source' = NULL))
}
\if{html}{\out{</div>}}

}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-print"></a>}}
\if{latex}{\out{\hypertarget{method-print}{}}}
\subsection{Method \code{print()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FileCabinet$print()}\if{html}{\out{</div>}}
}

\subsection{Details}{
Print an object of class FileCabinet.
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FileCabinet$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
