## CustomerSuccess Balancing


This challenge consists of a balancing system between customers and Customer Success (CSs). The CSS are the Success Managers, they are responsible for the strategic follow-up of customers.

Customer size products - we refer to the size of the company - we put more experienced CS to serve - here them.

A CS can serve more than one customer and in addition CSs can also go out, take a vacation, or even go on a happy vacation. It is necessary to take these criteria into account when running a distribution.

Given this scenario, the customer distribution system with the CS with the closest (larger) service capacity to the size of the customer.

**Example:**

If we have 6 clients with the following levels: 20, 30, 35, 40, 60, 80 and two CSs of levels 50 and 100, the system should distribute them as follows:

- 20, 30, 35, 40 for CS level 50
- 60 and 80 for level 100 CS

Where `n` is the number of CSs, `m` is the number of customers and `t` is the number of CS abstentions, calculate which customers will be served by which CSs according to the rules presented.


**Comments:**

- All CSs have different levels
- No customer limit per CS
- A customer can be left unattended
- Clients can be the same size
- 0 < n < 1,000
- 0 < m < 1,000,000
- 0 < cs id < 1000
- 0 < customer id < 1,000,000
- 0 < cs level < 10,000
- 0 < customer size < 100,000
- Maximum value of t = n/2 rounded down

# Input Format

The class takes 3 parameters:

- CS experience id and level
- Customer id and experience level
- unavailable CustomerSuccess ids


# Output Format

The expected result should be the id of the CS that serves the most clients. With this amount, the company will be able to make an action plan to hire more CS's of an approximate level.

In case of a tie, return 0.

**Example:** In the example input, CS's 2 and 4 are off. CS 1 will serve clients up to size 60, therefore clients 2, 4, 5, 6 while CS 3 will serve clients 1 and 3.

For this example, the return must be the id of 1, which is the CS that serves 4 customers:

```
1
```
