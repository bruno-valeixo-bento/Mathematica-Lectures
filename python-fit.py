import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit


# -----------------------------
# Model: y(t) = x0 + v0*t + 1/2*a0*t^2
# -----------------------------
def model(t, y0, v0, g):
    return y0 + v0 * t - 0.5 * g * t**2


# -----------------------------
# Load CSV
# -----------------------------
filename = "data.csv"   # <-- change this to your file
df = pd.read_csv(filename)

t = df["t"].values
y = df["y"].values
dy = df["dy"].values


# -----------------------------
# Weighted fit
# -----------------------------
popt, pcov = curve_fit(
    model,
    t,
    y,
    sigma=dy,
    absolute_sigma=True
)

y0_fit, v0_fit, g_fit = popt
dy0, dv0, dg = np.sqrt(np.diag(pcov))

print("Best fit parameters:")
print(f"y0 = {y0_fit:.3f} +- {dy0:.3f}")
print(f"v0 = {v0_fit:.3f} +- {dv0:.3f}")
print(f"g = {g_fit:.3f} +- {dg:.3f}")

# -----------------------------
# Save to CSV
# -----------------------------
params_df = pd.DataFrame({
    "parameter": ["y0", "v0", "g"],
    "value": [y0_fit, v0_fit, g_fit],
    "uncertainty": [dy0, dv0, dg]
})

params_df.to_csv("fit_parameters.csv", index=False)
print("Saved best-fit parameters to fit_parameters.csv")


# -----------------------------
# Plot
# -----------------------------
# t_fit = np.linspace(t.min(), t.max(), 500)
# y_fit = model(t_fit, *popt)

# plt.errorbar(t, y, yerr=dy, fmt='o', capsize=4, label="Data")
# plt.plot(t_fit, y_fit, label="Best fit")

# plt.xlabel("t")
# plt.ylabel("y")
# plt.legend()
# plt.grid(True)
# plt.show()