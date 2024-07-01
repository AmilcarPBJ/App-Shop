import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_2/models/product.dart';
import 'package:shop_2/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    final BuildContext context = this.context;

    try {
      await Provider.of<ProductList>(
        context, 
        listen: false
      ).saveProduct(_formData);

      if (context.mounted) {
        Navigator.of(context).pop();
      }

    } catch (error) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Ocorreu um erro!'),
            content: const Text('Ocorreu um erro ao salvar o produto.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Ok')),
            ],
          )
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name']
                            ?.toString(), // Outra opção seria (_formData['name'] ?? '') as String
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        }, //Com implementação da linha anterior onde tem ´.next´isso por padrão já faz mas tivemos que codar só pra ver como funciona passar o foco para um elemento específico.
                        onSaved: (name) => _formData['name'] = name ?? '',
                        validator: (_name) {
                          final name = _name ?? '';

                          if (name.trim().isEmpty) {
                            //trim() serve pra tirar os espaços em branco.
                            return 'Nome é obrigatório';
                          }

                          if (name.trim().length < 3) {
                            return 'Nome precisa no mínimo de 3 letras.';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['price']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Preço',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        onSaved: (price) =>
                            _formData['price'] = double.parse(price ?? '0'),
                        validator: (_price) {
                          final priceString = _price ?? '';
                          final price = double.tryParse(priceString) ?? -1;

                          if (price <= 0) {
                            return 'Informe um preço válido';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['description']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _descriptionFocus,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (description) =>
                            _formData['description'] = description ?? '',
                        validator: (_description) {
                          final description = _description ?? '';

                          if (description.trim().isEmpty) {
                            //trim() serve pra tirar os espaços em branco.
                            return 'Descrição é obrigatório';
                          }

                          if (description.trim().length < 10) {
                            return 'Descrição precisa no mínimo de 10 letras.';
                          }

                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Url da Imagem ',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                focusNode: _imageUrlFocus,
                                controller: _imageUrlController,
                                onFieldSubmitted: (_) => _submitForm(),
                                onSaved: (imageUrl) =>
                                    _formData['imageUrl'] = imageUrl ?? '',
                                validator: (_imageUrl) {
                                  final imageUrl = _imageUrl ?? '';
                                  if (!isValidImageUrl(imageUrl)) {
                                    return 'Informe uma Url válida.';
                                  }

                                  return null;
                                }),
                          ),
                          Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: _imageUrlController.text.isEmpty
                                  ? const Text("Informe a URL")
                                  : Image.network(_imageUrlController.text)),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
