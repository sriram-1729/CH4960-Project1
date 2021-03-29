# Finding out the infinite multiplication factor of a nuclear reactor via a Monte Carlo simulation (CH4960 Course Project)

The infinite multiplication factor of a nuclear reactor (k) is the ratio of the number of neutrons produced in the nth generation and the number of neutrons produced in the (n-1)th generation. Ideally, k should be close to 1, which would imply that the reactor is producing energy at a steady rate. If it is less than 1, it would mean that the nuclear reaction would die down. If it is greater than 1, we would have a bomb instead of a nuclear reactor.

In the reactor that I've simulated, I have taken enriched uranium as the fuel and light water as the moderator. The fuel rods have been assumed to be encased in pure zirconium, although in practice it is encased in a zirconium alloy.

## Procedure

1. We first fix the design of the reactor and count the number of atoms of each element present.
2. We fix the total number of Generation A neutrons present. I have taken it to be 10,000.
3. We generate the random number RND1 which gives every neutron in Generation A an initial amount of energy. The probability density function used to generate RND1 is the fission neutron energy spectrum given in the problem statement.
4. We generate RND2 which determines which nucleus the neutron is going to interact with. The probability density function is based on the number of nuclei of every element present.
5. We generate RND3 to determine the kind of interaction (fission, scattering or capture) that takes place between the nucleus and the neutron.
6. This step varies for different interactions:
   - When scattering takes place, we calculate the amount of energy the neutron has left and update RND1 accordingly. We then go to step 4.
   - When neutron capture takes place, the neutron is lost. So, we take a new neutron and go to step 5.
   - When the interaction is fission, we count the number of Generation B neutrons produced, and we consider the old neutron lost. So, we take a new neutron and go back to step 5.
7. Once all the Generation A neutrons have been exhausted, we divide the number of Generation B neutrons by the number of Generation A neutrons taken initially. This is the value of k obtained by this method.

## Additional details

All the assumptions taken to complete this project and additional info about the project can be found in `Project 1.pdf`. The sources for the data used in the project are stored in `data/SOURCES.txt`.
