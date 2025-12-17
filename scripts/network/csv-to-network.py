import csv
import networkx as nx

# Create an empty graph
G = nx.Graph()

# ---- Load nodes ----
nodes_file = '/Users/lilianam/workspace/hi-generic-letter-metadata-editor/csv/output/nodes-buchelius-20251205-tested.csv'
edges_file = '/Users/lilianam/workspace/hi-generic-letter-metadata-editor/csv/output/edges-buchelius-20251205-tested.csv'

with open(nodes_file, 'r', newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        G.add_node(row['Id'], label=row.get('Name', row['Id']))

# ---- Load edges ----
with open(edges_file, 'r', newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        # convert weight to number if it exists
        # weight = float(row['Weight']) if 'Weight' in row and row['Weight'] else 1
        # G.add_edge(row['Source'], row['Target'], weight=weight)
        G.add_edge(row['Source'], row['Target'])

# ---- Export to GEXF ----
nx.write_gexf(G, "graph-buchelius-all.gexf")
print("Saved as graph.gexf")
