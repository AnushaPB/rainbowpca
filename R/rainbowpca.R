#' Rescale numeric values to an RGB channel
#'
#' @param x Numeric vector.
#' @param to Numeric vector of length 2. Output range.
#'
#' @return Numeric vector rescaled to `to`.
#' @export
rescale_channel <- function(x, to = c(0, 1)) {
  if (!is.numeric(x)) {
    stop("`x` must be numeric.", call. = FALSE)
  }

  rng <- range(x, na.rm = TRUE)

  if (!all(is.finite(rng)) || diff(rng) == 0) {
    return(rep(mean(to), length(x)))
  }

  (x - rng[1]) / diff(rng) * diff(to) + to[1]
}

#' Convert three PCA axes to RGB colors
#'
#' Converts a numeric matrix (or data frame) into RGB colors
#' by independently rescaling each column to the range [0, 1].
#' Defaults to plotting first three columns as red, green, and blue, 
#' but the `order` argument allows you to specify which columns should 
#' map to which channels.
#'
#' @param x A numeric matrix or data frame
#' @param order Integer vector of length 3 specifying which columns should map
#'   to the red, green, and blue channels, respectively.
#'
#' @return A tibble containing:
#' \describe{
#'   \item{R}{Rescaled red channel}
#'   \item{G}{Rescaled green channel}
#'   \item{B}{Rescaled blue channel}
#'   \item{color}{RGB color string}
#' }
#'
#' @examples
#' pcs <- matrix(rnorm(300), ncol = 3)
#'
#' rgb_df <- pca_to_rgb(pcs)
#'
#' # Swap channels
#' rgb_df2 <- pca_to_rgb(pcs, order = c(3, 1, 2))
#'
#' @export
pca_to_rgb <- function(x, order = c(1, 2, 3)) {

  if (!is.matrix(x) && !is.data.frame(x)) {
    stop("`x` must be a matrix or data frame.", call. = FALSE)
  }

  x <- as.matrix(x)

  if (!is.numeric(x)) {
    stop("`x` must be numeric.", call. = FALSE)
  }

  if (length(order) != 3) {
    stop("`order` must be a vector of length 3.", call. = FALSE)
  }

  scaled <- apply(
    x,
    2,
    rescale_channel,
    to = c(0, 1)
  )

  scaled <- scaled[, order, drop = FALSE]

  out <- tibble::tibble(
    R = scaled[, 1],
    G = scaled[, 2],
    B = scaled[, 3]
  )

  out$color <- grDevices::rgb(
    red = out$R,
    green = out$G,
    blue = out$B
  )

  out
}
