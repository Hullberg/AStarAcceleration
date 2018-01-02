
#ifndef CONNECTIONS_H_
#define CONNECTIONS_H_

#include <stdint.h>

namespace maxcompilersim {

/*
 * Abstract connection class...
 */

class Connection {
public:
	virtual Connection* clone() = 0;
};

/* Type of port: t_port_number
 *                is defined as a 32-bit integer type.
 * Rationale: Ports are numbered from 0 to max so that we can easily
 *            use switch-statements.
 */
typedef uint32_t t_port_number;

} // namespace

#endif /* CONNECTIONS_H_ */
