# Non-volatile memory simulator

# target := tsvtest
TARGET := ./config/destiny

# define tool chain
CXX := g++
RM := rm -f

# define build options
# compile options
CXXFLAGS := -Wall 
# link options
LDFLAGS :=
# link librarires
LDLIBS :=

OUTDIR := obj

# construct list of .cpp and their corresponding .o and .d files
SRC := $(wildcard *.cpp)
INC := 
DBG :=
OBJ := $(patsubst %.cpp,$(OUTDIR)/%.o,$(notdir $(SRC)))
DEP := Makefile.dep

# file disambiguity is achieved via the .PHONY directive
.PHONY : all clean dbg

all: CXXFLAGS += -O3 -mtune=native
all: dir $(TARGET)

dbg: DBG += -ggdb -g #-DNVSIM3DDEBUG=1
dbg: dir $(TARGET)

dir:
	mkdir -p $(OUTDIR)

$(TARGET): $(OBJ)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

clean:
	$(RM) $(TARGET) $(dep_file) $(OBJ)

$(OUTDIR)/%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(DBG) $(INC) -c $< -o $@


# TODO: parametrize this line 
gdb_run: 
	cd config && \
	gdb --args ./destiny ./sample_2D_eDRAM.cfg


depend $(DEP):
	@echo Makefile - creating dependencies for: $(SRC)
	@$(RM) $(DEP)
	@$(CXX) -E -MM $(INC) $(SRC) >> $(DEP)

ifeq (,$(findstring clean,$(MAKECMDGOALS)))
-include $(DEP)
endif
