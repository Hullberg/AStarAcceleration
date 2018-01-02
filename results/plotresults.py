import matplotlib.pyplot as plt
def fileToList(filename):
    with open(filename,"r") as fp:
        result = []
        for line in fp:
            if len(line)> 0:
                result.append(float(line)*1000)

    return result

def vertexCountList():
    maximum = 2048
    multiplier = 10000
    n = 4
    vertex_list = []
    while n <= 2048:
        vertex_list.append(n*multiplier)
        n *=2
    return vertex_list

def plot_results(vertex_count,c_code,maxeler_code):
    plt.plot(vertex_count,c_code, label ="C")
    plt.plot(vertex_count,maxeler_code, label = "Maxeler")
    plt.ylabel("Time[ms]")
    plt.xlabel("Vertex count")
    plt.legend(loc= "upper left")
    plt.title("Maxeler vs C")
    plt.show()

if __name__ == "__main__":
    c_code = fileToList("c_code_edges_4.txt")
    maxeler_code = fileToList("maxeler_edges_4.txt")
    vertex_list = vertexCountList()
    print vertex_list
    plot_results(vertex_list,c_code,maxeler_code)

    

