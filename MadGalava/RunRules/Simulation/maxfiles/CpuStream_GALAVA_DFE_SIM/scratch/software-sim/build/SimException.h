#ifndef SIMEXCEPTION_H_
#define SIMEXCEPTION_H_

#include <exception>
#include  <iomanip>
#include <sstream>
#include <string>
#include <assert.h>
#include <execinfo.h>

namespace maxcompilersim {

class bfmt {
  std::string s;
  int arg_num;

  void replace(size_t pos, const std::string r, int modifier_len) {
    std::string new_s(s, 0, pos);
    new_s.append(r);
    new_s.append(s, pos + modifier_len, s.length() - pos - modifier_len);
    s = new_s;
  }


  template<typename T>
  void evaluateBoostFmt(const T &arg) {
    std::stringstream arg_s;
    arg_s << '%' << arg_num << '%';

    size_t pos = s.find(arg_s.str());
    if (pos == std::string::npos)
      return;

	std::stringstream is;
	is << arg;
	replace(pos, is.str(), arg_s.str().length());

    arg_num++;
  }

  void checkForDoublePercent() {
	size_t pos = 0;

	while (pos < s.length()) {
	  if (s[pos] == '%') {
		if (pos < (s.length() - 1)) {
		  pos++;
		  if (s[pos] != '%')
			return;
		  pos++;
		  continue;
		}
	  }
	  pos++;
	}

	char *str = NULL;
	asprintf(&str, s.c_str());
	s = std::string(str);
	free(str);
  }

  bool isFlag(char c, std::ios_base::fmtflags &fmtflags, char &fill) const {
  	  switch (c) {
		case '0':
		  fill = '0';
		  return true;
		case '+':
		  fmtflags |= std::ios_base::showpos;
		  return true;
		case '#':
		  fmtflags |= std::ios_base::showpoint | std::ios_base::showbase;
		  return true;
		case '-':
		case ' ':
		case '\'':
		  return true;
		default:
		  return false;
	  }
}

  int formatSpecifierLength(size_t pos, char &format, std::ios_base::fmtflags &fmtflags, std::streamsize &width, std::streamsize &precision, char &fill) const {
	size_t init_pos = pos;
	// Expect zero or more flags
	while (pos < s.length()) {
	  if (!isFlag(s[pos], fmtflags, fill))
		break;
	  pos++;
	}

	// Field width
	bool found = false;
	size_t width_start = 0;
	while (pos < s.length()) {
	  if (s[pos] < '0' || s[pos] > '9')
		break;
	  if (!found) {
		width_start = pos;
		found = true;
	  }
	  pos++;
	}

	if (found) {
	  width = std::stoi(std::string(s, width_start, width_start - pos));
	} else
	  width = -1;

	// Precision
	if (s[pos] == '.') {
	  pos++;
	  size_t start_pos = pos;
	  while (pos < s.length()) {
		if (s[pos] < '0' || s[pos] > '9')
		  break;
		pos++;
	  }
	  precision = std::stoi(std::string(s, start_pos, pos - start_pos));
	} else
	  precision = -1;

	// Length modifier
	switch (s[pos]) {
	  case 'h':
		pos++;
		if (s[pos] == 'h')
		  pos++;
		break;
	  case 'l':
		pos++;
		if (s[pos] == 'l') {
		  pos++;
		}
		break;
	  case 'L':
	  case 'q':
	  case 'j':
	  case 'z':
	  case 't':
		pos++;
	}

	// Conversion specifier
	format = s[pos];
	switch (s[pos]) {
	  case 'E':
	  case 'e':
		fmtflags |= std::ios_base::scientific;
		break;
	  case 'F':
	  case 'f':
		fmtflags |= std::ios_base::fixed;
		break;
	  case 'X':
	  case 'x':
		fmtflags &= ~std::ios_base::basefield;
		fmtflags |=  std::ios_base::hex;
		break;
	  case 'o':
		fmtflags &= ~std::ios_base::basefield;
		fmtflags |=  std::ios_base::oct;
		break;
	}

	switch (s[pos]) {
	  case 'E':
	  case 'F':
	  case 'G':
	  case 'X':
		fmtflags |= std::ios_base::uppercase;
	}

	pos++;

	return pos - init_pos;
  }

  template<typename T>
  typename std::enable_if<std::is_pod<T>::value, int>::type print (char **str, const char *fmt, char format,
	  std::ios_base::fmtflags fmtflags, std::streamsize width, std::streamsize precision, char fill, const T &arg) {
	return asprintf(str, fmt, arg);
  }

  template<typename T>
  typename std::enable_if<!std::is_pod<T>::value, int>::type print (char **str, const char *fmt, char format,
	  std::ios_base::fmtflags fmtflags, std::streamsize width, std::streamsize precision, char fill, const T &arg) {
	std::stringstream ss;
	if (width != -1)
	  ss.width(width);
	if (precision != -1)
	  ss.precision(precision);
	ss.flags(fmtflags);
	if (fill != -1)
	  ss.fill(fill);
	ss << arg;
	std::string s = ss.str();

	switch (format) {
	  case 'c':
		  return asprintf(str, fmt, *s.c_str());
	  case 's':
		  return asprintf(str, fmt, s.c_str());
	  case 'd':
	  case 'i':
	  case 'o':
	  case 'u':
	  case 'x':
	  case 'X':
	  case 'a':
	  case 'A':
	  case 'g':
	  case 'G':
	  case 'f':
	  case 'F':
		  return asprintf(str, "%s", s.c_str());
	  default:
		assert(0 && "TODO");
	}

	return -1;
  }


  template<typename T>
  void evaluatePrintfFmt(const T &arg) {
	size_t pos = 0;

	while (pos < s.length()) {
	  if (s[pos] == '%') {
		if (pos < (s.length() - 1)) {
		  size_t start = pos++;	// skip the first %
		  // check for second %
		  if (s[pos] == '%') {
			pos++;
			continue;
		  }

		  char format;
		  std::ios_base::fmtflags fmtflags = std::ios_base::skipws | std::ios_base::dec;
		  std::streamsize width;
		  std::streamsize precision;
		  char fill = -1;
		  pos += formatSpecifierLength(pos, format, fmtflags, width, precision, fill);	// the % specifier can be of almost any length
		  std::string new_s(s, 0, start);
		  std::string fmt(s, start, pos - start);
		  char *str = NULL;
		  print(&str, fmt.c_str(), format, fmtflags, width, precision, fill, arg);
		  new_s.append(str);
		  free(str);
		  new_s.append(std::string(s, pos, s.length() - pos));
		  s = new_s;

		  // Check that there are only %% left and convert them to %
		  checkForDoublePercent();
		  return;
		}
	  }
	  pos++;
	}
  }

  public:
  bfmt(const char *str) : s(str), arg_num(1) { }

  template<typename T>
  bfmt& operator% (const T &arg) {
    std::stringstream arg_s;
    arg_s << '%' << arg_num << '%';

	if (s.find(arg_s.str()) != std::string::npos)
	  evaluateBoostFmt(arg);
	else
	  evaluatePrintfFmt(arg);

    return *this;
  }

  const std::string str() const {
    return s;
  }
};

/* Base class for all exceptions used within the simulator.
 * Unless caught, the user will be notified about the exception
 * and will see the exception message!
 */
class SimException :
	public virtual std::exception
{
protected:
	std::string m_what;

	// to get useful stack traces, compile simulation
	// with debug information turned on AND
	// optimizations turned off...
	void doBackTrace()
	{
		void *array[11];
		size_t size = backtrace(array, 10);
		char **strings = backtrace_symbols (array, size);
		std::string backtrace;
		for (size_t i = 0; i < size; i++)
		{
			backtrace += "\n";
			backtrace += strings[i];
		}
		free (strings);
		m_what += "\n Backtrace: ";
		m_what += backtrace;
	}

public:
	SimException(const char *msg):
		m_what(msg)
	{
		doBackTrace();
	}

	SimException(const std::string &msg):
		m_what(msg)
	{
		doBackTrace();
	}

	SimException(const bfmt &fmt) :
		m_what(fmt.str())
	{
		doBackTrace();
	}

	SimException (const SimException &e) {
		m_what = e.m_what;
	}

	SimException& operator<< (bfmt &fmt) {
		m_what += fmt.str();
		doBackTrace();
		return *this;
	}

	virtual ~SimException() throw () {}

	virtual const char *what() const throw() { return m_what.c_str(); }
};


/* Base class for all exceptions that need to stay silent:
 * The simulation will still terminate if this exception is not caught but
 * the user won't be notified. See SimTerminator.cpp for an example.
 * Hence, you really don't want to throw a SimCleanHaltException.
 */
class SimCleanHaltException :
	public SimException
{
public:
	SimCleanHaltException(const char *msg) :SimException(msg) {}

	SimCleanHaltException(const std::string &msg) :SimException(msg) {}

	SimCleanHaltException(const bfmt &fmt) : SimException(fmt) {}

	virtual ~SimCleanHaltException() throw () {}
};

class InputException:
	public SimException
{
	std::string m_input_name;
public:
	InputException(const std::string &input_name, const std::string &msg) :SimException(msg), m_input_name(input_name) {}
	InputException(const std::string &input_name, const bfmt &fmt) : SimException(fmt), m_input_name(input_name) {}
	virtual ~InputException() throw () {}

	const std::string& getInputName() const throw() {return m_input_name; }
};

/* Thrown in JavaSim mode when input is done but
 * a kernel wants to read the input
 */
class InputDoneException:
	public InputException
{
public:
	InputDoneException(const std::string &input_name, const std::string &msg) :InputException(input_name,msg){}
	InputDoneException(const std::string &input_name, const bfmt &fmt) : InputException(input_name,fmt){}
	virtual ~InputDoneException() throw () {}
};

/* Thrown in JavaSim mode when a kernel attempts to
 * read from an empty input.
 */
class InputEmptyException:
	public InputException
{
public:
	InputEmptyException(const std::string &input_name, const std::string &msg) : InputException(input_name, msg) {}
	InputEmptyException(const std::string &input_name, const bfmt &fmt) : InputException(input_name, fmt) {}
	virtual ~InputEmptyException() throw () {}
};

}

#endif /* SIMEXCEPTION_H_ */
